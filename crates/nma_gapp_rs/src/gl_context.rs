use std::{ffi::c_void, sync::Mutex};

use glutin::{
    context::PossiblyCurrentContext,
    prelude::{GlDisplay, NotCurrentGlContext, PossiblyCurrentGlContext},
    surface::{GlSurface, PbufferSurface, Surface, WindowSurface},
};

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
pub struct GlRenderContext {
    /// The main context for rendering to the window.
    /// Wrapped in an Option because we might need to take ownership to change its state (current/not current).
    pub render_context: Mutex<Option<PossiblyCurrentContext>>,
    /// The window surface corresponding to the visible window.
    pub surface: Surface<WindowSurface>,

    /// The background context for resource loading.
    pub resource_context: Mutex<Option<PossiblyCurrentContext>>,
    /// An off-screen surface (Pixel Buffer) for the resource context.
    pub resource_surface: Surface<PbufferSurface>,

    /// The connection to the display server (e.g., Wayland or X11).
    pub display: glutin::display::Display,
}

impl GlRenderContext {
    /// Makes the main render context current on this thread.
    ///
    /// This tells the GPU driver that subsequent OpenGL commands on this thread
    /// should target the window surface using the render context.
    pub fn make_current(&self) -> bool {
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
    pub fn clear_current(&mut self) -> bool {
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
    pub fn present(&self) -> bool {
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
    pub fn make_resource_current(&self) -> bool {
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
    pub fn fbo(&self) -> u32 {
        0
    }

    /// dynamically resolves OpenGL function pointers.
    ///
    /// This allows the Flutter engine to call OpenGL functions (like `glDrawArrays`, `glClear`)
    /// without linking directly to `libGL.so`. It asks the windowing system (Glutin) for the address of the function.
    pub fn resolve_proc(&self, name: *const i8) -> *mut c_void {
        unsafe {
            let c_str = std::ffi::CStr::from_ptr(name);
            self.display.get_proc_address(c_str) as *mut c_void
        }
    }
}
