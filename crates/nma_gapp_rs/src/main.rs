use std::{
    ffi::{c_void, CString},
    num::NonZeroU32,
    ptr,
    sync::Mutex,
};

use glutin::{
    config::{ConfigTemplateBuilder, GlConfig},
    context::{ContextAttributesBuilder, PossiblyCurrentContext},
    display::GetGlDisplay,
    prelude::{GlDisplay, NotCurrentGlContext, PossiblyCurrentGlContext},
    surface::{GlSurface, Surface, SurfaceAttributesBuilder, WindowSurface},
};
use glutin::{display::Display, surface::PbufferSurface};
use glutin_winit::DisplayBuilder;
use raw_window_handle::HasWindowHandle;
use winit::{
    application::ApplicationHandler, dpi::PhysicalSize, event::WindowEvent, event_loop::EventLoop,
    window::Window,
};

use flutter_embedder_sys::*;

/// Holds the OpenGL state required by the Flutter Engine.
///
/// Flutter requires two OpenGL contexts:
/// 1. `render_context`: Used for the actual rasterization of the UI onto the window surface.
///    This is the "main" context associated with the visible window.
/// 2. `resource_context`: Used for background tasks like texture uploads and shader compilation.
///    This context shares resources (textures, shaders) with the render context but
///    renders to an invisible "pbuffer" surface to avoid blocking the main thread.
///
/// We use `Mutex` because the Flutter engine might invoke callbacks from different threads,
/// although in this simple example, most work happens on the platform thread.
struct GlRenderContext {
    /// The main context for rendering to the window.
    /// Wrapped in an Option because we might need to take ownership to change its state (current/not current).
    render_context: Mutex<Option<PossiblyCurrentContext>>,
    /// The window surface corresponding to the visible window.
    surface: Surface<WindowSurface>,

    /// The background context for resource loading.
    resource_context: Mutex<Option<PossiblyCurrentContext>>,
    /// An off-screen surface (Pixel Buffer) for the resource context.
    resource_surface: Surface<PbufferSurface>,

    /// The connection to the display server (e.g., Wayland or X11).
    display: Display,
}

impl GlRenderContext {
    /// Makes the main render context current on this thread.
    ///
    /// This tells the GPU driver that subsequent OpenGL commands on this thread
    /// should target the window surface using the render context.
    fn make_current(&self) -> bool {
        let guard = self.render_context.lock().unwrap();
        if let Some(ctx) = guard.as_ref() {
            // Bind the context to the surface.
            ctx.make_current(&self.surface).is_ok()
        } else {
            false
        }
    }

    /// Clears the current context from this thread.
    ///
    /// This is important because an OpenGL context can typically only be current on one thread at a time.
    /// Before Flutter can use this context on another thread (if it chose to), we must release it.
    fn clear_current(&mut self) -> bool {
        let mut guard = self.render_context.lock().unwrap();
        if let Some(ctx) = guard.take() {
            // Glutin consumes the context to make it not current, returning a `NotCurrentContext`.
            match ctx.make_not_current() {
                Ok(not_current) => {
                    // We immediately treat it as "possibly current" again to store it back,
                    // ready for the next time we need to make it current.
                    *guard = Some(not_current.treat_as_possibly_current());
                    true
                }
                Err(e) => {
                    eprintln!("Failed to clear current context: {:?}", e);
                    false
                }
            }
        } else {
            false
        }
    }

    /// Swaps the buffers to present the rendered frame to the screen.
    ///
    /// In a double-buffered setup, drawing happens on the back buffer.
    /// This command swaps the back buffer to the front, making the new frame visible.
    fn present(&self) -> bool {
        let guard = self.render_context.lock().unwrap();
        if let Some(ctx) = guard.as_ref() {
            self.surface.swap_buffers(ctx).is_ok()
        } else {
            false
        }
    }

    /// Makes the resource (background) context current.
    ///
    /// Used by Flutter for async texture uploads without blocking the main render thread.
    fn make_resource_current(&self) -> bool {
        let guard = self.resource_context.lock().unwrap();
        if let Some(ctx) = guard.as_ref() {
            ctx.make_current(&self.resource_surface).is_ok()
        } else {
            false
        }
    }

    /// Returns the Framebuffer Object (FBO) ID.
    ///
    /// For a standard window surface, the default FBO ID is usually 0.
    fn fbo(&self) -> u32 {
        0
    }

    /// dynamically resolves OpenGL function pointers.
    ///
    /// This allows the Flutter engine to call OpenGL functions (like `glDrawArrays`, `glClear`)
    /// without linking directly to `libGL.so`. It asks the windowing system (Glutin) for the address of the function.
    fn resolve_proc(&self, name: *const i8) -> *mut c_void {
        unsafe {
            let c_str = std::ffi::CStr::from_ptr(name);
            self.display.get_proc_address(c_str) as *mut c_void
        }
    }
}

// -----------------------------------------------------------------------------
// C-ABI Compatible Callbacks
// -----------------------------------------------------------------------------
// These functions are passed to the C-based Flutter Engine. They must match the
// function signatures defined in `embedder.h` and use the C calling convention (`extern "C"`).
// The `user_data` pointer allows us to bridge back to our Rust `GlRenderContext`.

unsafe extern "C" fn gl_make_current(user_data: *mut c_void) -> bool {
    let ctx = &*(user_data as *mut GlRenderContext);
    ctx.make_current()
}

unsafe extern "C" fn gl_clear_current(user_data: *mut c_void) -> bool {
    let ctx = &mut *(user_data as *mut GlRenderContext);
    ctx.clear_current()
}

unsafe extern "C" fn gl_present(user_data: *mut c_void) -> bool {
    let ctx = &*(user_data as *mut GlRenderContext);
    ctx.present()
}

unsafe extern "C" fn gl_make_resource_current(user_data: *mut c_void) -> bool {
    let ctx = &*(user_data as *mut GlRenderContext);
    ctx.make_resource_current()
}

unsafe extern "C" fn gl_fbo_callback(user_data: *mut c_void) -> u32 {
    let ctx = &*(user_data as *mut GlRenderContext);
    ctx.fbo()
}

unsafe extern "C" fn gl_proc_resolver(user_data: *mut c_void, name: *const i8) -> *mut c_void {
    let ctx = &*(user_data as *mut GlRenderContext);
    ctx.resolve_proc(name)
}

// -----------------------------------------------------------------------------
// Application State
// -----------------------------------------------------------------------------

struct App {
    /// The OS window.
    window: Option<winit::window::Window>,
    /// We box the context to ensure it has a stable memory address.
    /// This address is passed to C code as `user_data`, so it must not move in memory.
    render_context: Option<Box<GlRenderContext>>,
    /// Handle to the running Flutter Engine instance.
    engine: FlutterEngine,
}

impl Default for App {
    fn default() -> Self {
        Self {
            window: None,
            render_context: None,
            engine: ptr::null_mut(),
        }
    }
}

impl ApplicationHandler for App {
    /// Called when the application is started/resumed. This is where we initialize everything.
    fn resumed(&mut self, event_loop: &winit::event_loop::ActiveEventLoop) {
        // 1. Configure the Window and OpenGL requirements.
        let template = ConfigTemplateBuilder::new().with_alpha_size(8); // Request an alpha channel for transparency support.

        let window_attrs = Window::default_attributes()
            .with_title("Flutter Rust Embedder")
            .with_inner_size(PhysicalSize::new(800, 600));

        let display_builder = DisplayBuilder::new().with_window_attributes(Some(window_attrs));

        // 2. Create the Window and find a suitable OpenGL Configuration.
        let (window, gl_config) = display_builder
            .build(event_loop, template, |configs| {
                // Find the config with the maximum number of samples (multisampling/anti-aliasing).
                configs
                    .reduce(|accum, config| {
                        if config.num_samples() > accum.num_samples() {
                            config
                        } else {
                            accum
                        }
                    })
                    .unwrap()
            })
            .unwrap();

        let window = window.unwrap();
        let raw_window_handle = window.window_handle().unwrap().as_raw();

        // 3. Create the Main Render Context (associated with the window).
        let context_attrs = ContextAttributesBuilder::new().build(Some(raw_window_handle));
        let display = gl_config.display();

        let surface_attrs = SurfaceAttributesBuilder::<WindowSurface>::new().build(
            raw_window_handle,
            NonZeroU32::new(800).unwrap(),
            NonZeroU32::new(600).unwrap(),
        );
        let surface = unsafe {
            display
                .create_window_surface(&gl_config, &surface_attrs)
                .unwrap()
        };

        // Create the context but don't make it current yet.
        let render_context_not_current =
            unsafe { display.create_context(&gl_config, &context_attrs).unwrap() };

        // 4. Create the Resource Context (Background Context).
        // It shares resources (textures, etc.) with the main render context.
        let resource_context_attrs = ContextAttributesBuilder::new()
            .with_sharing(&render_context_not_current)
            .build(Some(raw_window_handle));

        let resource_context_not_current = unsafe {
            display
                .create_context(&gl_config, &resource_context_attrs)
                .unwrap()
        };

        // Create a hidden 1x1 pbuffer surface for the resource context.
        let pbuffer_attrs = SurfaceAttributesBuilder::<PbufferSurface>::new()
            .build(NonZeroU32::new(1).unwrap(), NonZeroU32::new(1).unwrap());

        let resource_surface = unsafe {
            display
                .create_pbuffer_surface(&gl_config, &pbuffer_attrs)
                .unwrap()
        };

        // 5. Package everything into our struct.
        let render_context = render_context_not_current.treat_as_possibly_current();
        let resource_context = resource_context_not_current.treat_as_possibly_current();

        let render_context = Box::new(GlRenderContext {
            render_context: Mutex::new(Some(render_context)),
            surface,
            resource_context: Mutex::new(Some(resource_context)),
            resource_surface,
            display,
        });

        // Get the stable raw pointer to pass to the C engine.
        let user_data_ptr = &*render_context as *const GlRenderContext as *mut c_void;

        self.window = Some(window);
        self.render_context = Some(render_context);

        // 6. Configure the Flutter Engine Callbacks.
        let mut open_gl: FlutterOpenGLRendererConfig = unsafe { std::mem::zeroed() };
        open_gl.struct_size = std::mem::size_of::<FlutterOpenGLRendererConfig>();
        open_gl.make_current = Some(gl_make_current);
        open_gl.clear_current = Some(gl_clear_current);
        open_gl.present = Some(gl_present);
        open_gl.fbo_callback = Some(gl_fbo_callback);
        open_gl.make_resource_current = Some(gl_make_resource_current);
        open_gl.gl_proc_resolver = Some(gl_proc_resolver);
        open_gl.gl_external_texture_frame_callback = None;

        let renderer_config = FlutterRendererConfig {
            type_: FlutterRendererType_kOpenGL,
            // Rust doesn't natively support C unions well, so we use the bindgen generated fields.
            __bindgen_anon_1: FlutterRendererConfig__bindgen_ty_1 { open_gl },
            ..unsafe { std::mem::zeroed() }
        };

        // 7. Locate Flutter Assets.
        // We assume the assets are built in the standard location relative to the crate.
        // `FLUTTER_ROOT` is an environment variable pointing to the Flutter SDK.
        let flutter_sdk_path = env!("FLUTTER_ROOT");

        let assets = CString::new("../../apps/nma_gapp/build/flutter_assets").unwrap();
        let icu = CString::new(format!(
            "{}/bin/cache/artifacts/engine/linux-x64/icudtl.dat",
            flutter_sdk_path
        ))
        .unwrap();

        let args = FlutterProjectArgs {
            struct_size: std::mem::size_of::<FlutterProjectArgs>(),
            assets_path: assets.as_ptr(),
            icu_data_path: icu.as_ptr(),
            ..Default::default()
        };

        // 8. Launch the Flutter Engine.
        unsafe {
            let result = FlutterEngineRun(
                FLUTTER_ENGINE_VERSION as usize,
                &renderer_config,
                &args,
                user_data_ptr,
                &mut self.engine,
            );

            if result != FlutterEngineResult_kSuccess || self.engine.is_null() {
                panic!("Failed to start Flutter Engine: {:?}", result);
            }
        }

        // Notify Flutter of the initial window size.
        let size = self.window.as_ref().unwrap().inner_size();
        self.send_window_metrics(size);
    }

    fn window_event(
        &mut self,
        event_loop: &winit::event_loop::ActiveEventLoop,
        _window_id: winit::window::WindowId,
        event: winit::event::WindowEvent,
    ) {
        match event {
            WindowEvent::CloseRequested => {
                event_loop.exit();
            }
            WindowEvent::Resized(size) => {
                // When window resizes, we must update the GL surface and notify Flutter.
                if let Some(ctx) = &self.render_context {
                    let guard = ctx.render_context.lock().unwrap();
                    if let Some(c) = guard.as_ref() {
                        ctx.surface.resize(
                            c,
                            NonZeroU32::new(size.width).unwrap_or(NonZeroU32::new(1).unwrap()),
                            NonZeroU32::new(size.height).unwrap_or(NonZeroU32::new(1).unwrap()),
                        );
                    };
                }
                self.send_window_metrics(size);
            }
            _ => (),
        }
    }
}

impl App {
    /// Sends the new window dimensions and pixel ratio to the Flutter Engine.
    fn send_window_metrics(&self, size: PhysicalSize<u32>) {
        if self.engine.is_null() {
            return;
        }

        let scale_factor = self.window.as_ref().unwrap().scale_factor();
        let event = FlutterWindowMetricsEvent {
            struct_size: std::mem::size_of::<FlutterWindowMetricsEvent>(),
            width: size.width as usize,
            height: size.height as usize,
            pixel_ratio: scale_factor,
            view_id: 0, // 0 is the default implicit view ID.
            ..unsafe { std::mem::zeroed() }
        };

        unsafe {
            FlutterEngineSendWindowMetricsEvent(self.engine, &event);
        }
    }
}

fn main() {
    let event_loop = EventLoop::new().unwrap();
    event_loop.set_control_flow(winit::event_loop::ControlFlow::Wait);
    event_loop.run_app(&mut App::default()).unwrap();
}
