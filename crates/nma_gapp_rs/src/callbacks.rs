// -----------------------------------------------------------------------------
// C-ABI Compatible Callbacks
// -----------------------------------------------------------------------------
// These functions are passed to the C-based Flutter Engine. They must match the
// function signatures defined in `embedder.h` and use the C calling convention (`extern "C"`).
// The `user_data` pointer allows us to bridge back to our Rust `GlRenderContext`.

use std::ffi::c_void;

use crate::gl_context::GlRenderContext;

pub unsafe extern "C" fn gl_make_current(user_data: *mut c_void) -> bool {
    let ctx = &*(user_data as *mut GlRenderContext);
    ctx.make_current()
}

pub unsafe extern "C" fn gl_clear_current(user_data: *mut c_void) -> bool {
    let ctx = &mut *(user_data as *mut GlRenderContext);
    ctx.clear_current()
}

pub unsafe extern "C" fn gl_present(user_data: *mut c_void) -> bool {
    let ctx = &*(user_data as *mut GlRenderContext);
    ctx.present()
}

pub unsafe extern "C" fn gl_make_resource_current(user_data: *mut c_void) -> bool {
    let ctx = &*(user_data as *mut GlRenderContext);
    ctx.make_resource_current()
}

pub unsafe extern "C" fn gl_fbo_callback(user_data: *mut c_void) -> u32 {
    let ctx = &*(user_data as *mut GlRenderContext);
    ctx.fbo()
}

pub unsafe extern "C" fn gl_proc_resolver(user_data: *mut c_void, name: *const i8) -> *mut c_void {
    let ctx = &*(user_data as *mut GlRenderContext);
    ctx.resolve_proc(name)
}
