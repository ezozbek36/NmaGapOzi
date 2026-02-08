// -----------------------------------------------------------------------------
// Application State
// -----------------------------------------------------------------------------

mod config;
mod engine;
mod keyboard;

use glutin::{
    config::{ConfigTemplateBuilder, GlConfig},
    context::ContextAttributesBuilder,
    display::GetGlDisplay,
    prelude::{GlDisplay, NotCurrentGlContext},
    surface::{GlSurface, PbufferSurface, SurfaceAttributesBuilder, WindowSurface},
};
use glutin_winit::DisplayBuilder;
use raw_window_handle::HasWindowHandle;
use std::{num::NonZeroU32, sync::Mutex};
use winit::{
    application::ApplicationHandler,
    dpi::{PhysicalPosition, PhysicalSize},
    event::{ElementState, KeyEvent, Modifiers, MouseButton, MouseScrollDelta, WindowEvent},
    keyboard::ModifiersState,
    window::Window,
};

use crate::{app::engine::Engine, gl_context::GlRenderContext};

#[derive(Default)]
pub struct App {
    /// The OS window.
    window: Option<winit::window::Window>,
    /// We box the context to ensure it has a stable memory address.
    /// This address is passed to C code as `user_data`, so it must not move in memory.
    render_context: Option<Box<GlRenderContext>>,
    /// Handle to the running Flutter Engine instance.
    engine: Option<Engine>,
    modifiers_state: ModifiersState,
}

impl Drop for App {
    fn drop(&mut self) {
        self.engine.take();
        self.render_context.take();
        self.window.take();
    }
}

impl ApplicationHandler for App {
    /// Called when the application is started/resumed. This is where we initialize everything.
    fn resumed(&mut self, event_loop: &winit::event_loop::ActiveEventLoop) {
        // 1. Setup Project
        let project = config::Project::from_env();

        // 2. Setup Window & Graphics (Internal helper to keep resumed clean)
        let (window, context) = self.init_graphics(event_loop);

        // 3. Setup Engine
        let flutter_engine =
            engine::Engine::new(&context, &project).expect("Failed to initialize Flutter Engine");

        // 4. Update State
        let size = window.inner_size();
        let scale_factor = window.scale_factor();

        self.window = Some(window);
        self.render_context = Some(context);
        self.engine = Some(flutter_engine);

        // Notify engine of initial size
        self.engine.as_ref().unwrap().send_metrics(
            size.width as usize,
            size.height as usize,
            scale_factor,
        );

        self.engine.as_ref().unwrap().send_view_focus(true);
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
            WindowEvent::RedrawRequested => {
                self.handle_redraw();
            }
            WindowEvent::Resized(size) => self.handle_resize(size),
            WindowEvent::ScaleFactorChanged { scale_factor, .. } => {
                self.handle_scale_factor(scale_factor)
            }
            WindowEvent::Focused(focused) => self.handle_focus(focused),
            WindowEvent::CursorEntered { .. } => self.handle_cursor_entered(),
            WindowEvent::CursorLeft { .. } => self.handle_cursor_left(),
            WindowEvent::CursorMoved { position, .. } => self.handle_cursor_moved(position),
            WindowEvent::MouseInput { state, button, .. } => self.handle_mouse_input(state, button),
            WindowEvent::MouseWheel { delta, .. } => self.handle_mouse_wheel(delta),
            WindowEvent::KeyboardInput { event, .. } => self.handle_keyboard_input(event),
            WindowEvent::ModifiersChanged(state) => self.handle_modifiers_changed(state),
            _ => (),
        }
    }
}

impl App {
    fn handle_modifiers_changed(&mut self, state: Modifiers) {
        self.modifiers_state = state.state();
    }

    fn handle_redraw(&self) {
        if let Some(engine) = &self.engine {
            engine.schedule_frame();
        }
    }

    fn handle_keyboard_input(&self, event: KeyEvent) {
        if let Some(engine) = &self.engine {
            let prepared = keyboard::prepare_key_event(&event, Engine::current_time_micros());
            engine.send_key_event(&prepared.event);
        }
    }

    fn handle_focus(&self, focused: bool) {
        if let Some(engine) = &self.engine {
            engine.send_view_focus(focused);
        }
    }

    fn handle_scale_factor(&self, scale_factor: f64) {
        if let (Some(window), Some(engine)) = (&self.window, &self.engine) {
            let size = window.inner_size();
            engine.send_metrics(size.width as usize, size.height as usize, scale_factor);
        }
    }

    fn handle_resize(&mut self, size: PhysicalSize<u32>) {
        if let (Some(ctx), Some(window), Some(engine)) =
            (&self.render_context, &self.window, &self.engine)
        {
            let guard = ctx.render_context.lock().unwrap();

            if let Some(c) = guard.as_ref() {
                ctx.surface.resize(
                    c,
                    NonZeroU32::new(size.width).unwrap_or(NonZeroU32::new(1).unwrap()),
                    NonZeroU32::new(size.height).unwrap_or(NonZeroU32::new(1).unwrap()),
                );
            }

            engine.send_metrics(
                size.width as usize,
                size.height as usize,
                window.scale_factor(),
            );
        }
    }

    fn handle_cursor_entered(&mut self) {
        if let Some(engine) = self.engine.as_mut() {
            engine.handle_cursor_entered();
        }
    }

    fn handle_cursor_left(&mut self) {
        if let Some(engine) = self.engine.as_mut() {
            engine.handle_cursor_left();
        }
    }

    fn handle_cursor_moved(&mut self, position: PhysicalPosition<f64>) {
        if let Some(engine) = self.engine.as_mut() {
            engine.handle_cursor_moved(position.x, position.y);
        }
    }

    fn handle_mouse_input(&mut self, state: ElementState, button: MouseButton) {
        if let Some(engine) = self.engine.as_mut() {
            engine.handle_mouse_input(state, button);
        }
    }

    fn handle_mouse_wheel(&mut self, delta: MouseScrollDelta) {
        if let Some(engine) = self.engine.as_mut() {
            engine.handle_mouse_wheel(delta);
        }
    }

    /// Initializes the window and the dual-context OpenGL state.
    /// This method is designed to be called once during the `resumed` lifecycle event.
    fn init_graphics(
        &self,
        event_loop: &winit::event_loop::ActiveEventLoop,
    ) -> (Window, Box<GlRenderContext>) {
        // 1. Define Hardware Requirements
        // We request an 8-bit alpha channel to allow for potential transparency effects.
        let template = ConfigTemplateBuilder::new().with_alpha_size(8);

        let window_attrs = Window::default_attributes()
            .with_title("NmaGapOZi - Flutter Rust")
            .with_inner_size(PhysicalSize::new(800, 600));

        let display_builder = DisplayBuilder::new().with_window_attributes(Some(window_attrs));

        // 2. Select OpenGL Configuration
        // We pick the configuration with the highest sample count for better anti-aliasing.
        let (window, gl_config) = display_builder
            .build(event_loop, template, |configs| {
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
            .expect("Failed to create window or find valid GL config");

        let window = window.expect("Window creation failed");
        let raw_window_handle = window
            .window_handle()
            .expect("Failed to get raw window handle")
            .as_raw();

        let context_attrs = ContextAttributesBuilder::new().build(Some(raw_window_handle));
        let display = gl_config.display();

        // 3. Create Main Window Surface
        let surface_attrs = SurfaceAttributesBuilder::<WindowSurface>::new().build(
            raw_window_handle,
            NonZeroU32::new(800).unwrap(),
            NonZeroU32::new(600).unwrap(),
        );
        let surface = unsafe {
            display
                .create_window_surface(&gl_config, &surface_attrs)
                .expect("Failed to create window surface")
        };

        // 4. Create Shared Contexts
        // Flutter requires a 'Resource Context' shared with the 'Render Context'.
        let render_ctx_not_current = unsafe {
            display
                .create_context(&gl_config, &context_attrs)
                .expect("Failed to create main GL context")
        };

        let resource_ctx_attrs = ContextAttributesBuilder::new()
            .with_sharing(&render_ctx_not_current)
            .build(Some(raw_window_handle));

        let resource_ctx_not_current = unsafe {
            display
                .create_context(&gl_config, &resource_ctx_attrs)
                .expect("Failed to create resource GL context")
        };

        // 5. Create Resource Surface (Pbuffer)
        // Background tasks like texture uploads use this invisible 1x1 surface.
        let pbuffer_attrs = SurfaceAttributesBuilder::<PbufferSurface>::new()
            .build(NonZeroU32::new(1).unwrap(), NonZeroU32::new(1).unwrap());

        let resource_surface = unsafe {
            display
                .create_pbuffer_surface(&gl_config, &pbuffer_attrs)
                .expect("Failed to create resource pbuffer surface")
        };

        let render_context = render_ctx_not_current.treat_as_possibly_current();
        let resource_context = resource_ctx_not_current.treat_as_possibly_current();

        // 6. Return Structured State
        let context = Box::new(GlRenderContext {
            render_context: Mutex::new(Some(render_context)),
            surface,
            resource_context: Mutex::new(Some(resource_context)),
            resource_surface,
            display,
        });

        (window, context)
    }
}
