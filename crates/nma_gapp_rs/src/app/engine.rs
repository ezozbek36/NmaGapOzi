use flutter_embedder_sys::{
    FlutterEngineResult, FlutterEngineResult_kSuccess, FlutterOpenGLRendererConfig,
    FlutterRendererConfig, FLUTTER_ENGINE_VERSION,
};

use crate::{callbacks::*, gl_context::GlRenderContext};

pub struct Engine {
    /// Handle to the running Flutter Engine instance.
    pub handle: flutter_embedder_sys::FlutterEngine,
}

impl Engine {
    pub fn new(
        render_context: &GlRenderContext,
        project: &super::config::Project,
    ) -> Result<Self, FlutterEngineResult> {
        let mut engine = std::ptr::null_mut();

        let renderer_config = Self::create_renderer_config();
        let project_args = project.as_project_args();
        let user_data_ptr = render_context as *const GlRenderContext as *mut std::ffi::c_void;

        let result = unsafe {
            flutter_embedder_sys::FlutterEngineRun(
                FLUTTER_ENGINE_VERSION as usize,
                &renderer_config,
                &project_args,
                user_data_ptr,
                &mut engine,
            )
        };

        if result == FlutterEngineResult_kSuccess && !engine.is_null() {
            Ok(Self { handle: engine })
        } else {
            Err(result)
        }
    }

    pub fn send_metrics(&self, width: usize, height: usize, pixel_ratio: f64) {
        let event = flutter_embedder_sys::FlutterWindowMetricsEvent {
            struct_size: std::mem::size_of::<flutter_embedder_sys::FlutterWindowMetricsEvent>(),
            width,
            height,
            pixel_ratio,
            view_id: 0,
            ..unsafe { std::mem::zeroed() }
        };

        unsafe {
            flutter_embedder_sys::FlutterEngineSendWindowMetricsEvent(self.handle, &event);
        }
    }

    fn create_renderer_config() -> FlutterRendererConfig {
        let mut open_gl: FlutterOpenGLRendererConfig = unsafe { std::mem::zeroed() };
        open_gl.struct_size = std::mem::size_of::<FlutterOpenGLRendererConfig>();
        open_gl.make_current = Some(gl_make_current);
        open_gl.clear_current = Some(gl_clear_current);
        open_gl.present = Some(gl_present);
        open_gl.fbo_callback = Some(gl_fbo_callback);
        open_gl.make_resource_current = Some(gl_make_resource_current);
        open_gl.gl_proc_resolver = Some(gl_proc_resolver);
        open_gl.gl_external_texture_frame_callback = None;

        FlutterRendererConfig {
            type_: flutter_embedder_sys::FlutterRendererType_kOpenGL,
            __bindgen_anon_1: flutter_embedder_sys::FlutterRendererConfig__bindgen_ty_1 { open_gl },
            ..unsafe { std::mem::zeroed() }
        }
    }
}
