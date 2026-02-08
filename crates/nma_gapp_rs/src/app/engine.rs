use flutter_embedder_sys::{
    FlutterEngineResult, FlutterEngineResult_kSuccess, FlutterKeyEvent,
    FlutterOpenGLRendererConfig, FlutterPointerDeviceKind_kFlutterPointerDeviceKindMouse,
    FlutterPointerEvent, FlutterPointerMouseButtons_kFlutterPointerButtonMouseBack,
    FlutterPointerMouseButtons_kFlutterPointerButtonMouseForward,
    FlutterPointerMouseButtons_kFlutterPointerButtonMouseMiddle,
    FlutterPointerMouseButtons_kFlutterPointerButtonMousePrimary,
    FlutterPointerMouseButtons_kFlutterPointerButtonMouseSecondary, FlutterPointerPhase,
    FlutterPointerPhase_kAdd, FlutterPointerPhase_kDown, FlutterPointerPhase_kHover,
    FlutterPointerPhase_kMove, FlutterPointerPhase_kRemove, FlutterPointerPhase_kUp,
    FlutterPointerSignalKind_kFlutterPointerSignalKindNone,
    FlutterPointerSignalKind_kFlutterPointerSignalKindScroll, FlutterRendererConfig,
    FlutterViewFocusDirection_kUndefined, FlutterViewFocusEvent, FlutterViewFocusState_kFocused,
    FlutterViewFocusState_kUnfocused, FlutterWindowMetricsEvent, FLUTTER_ENGINE_VERSION,
};
use winit::event::{ElementState, MouseButton, MouseScrollDelta};

use crate::{callbacks::*, gl_context::GlRenderContext};

const IMPLICIT_VIEW_ID: i64 = 0;

#[derive(Default)]
pub struct Engine {
    /// Handle to the running Flutter Engine instance.
    handle: flutter_embedder_sys::FlutterEngine,

    cursor_x: f64,
    cursor_y: f64,
    pointer_added: bool,
    pointer_down: bool,
    pressed_buttons: i64,
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
            Ok(Self {
                handle: engine,
                ..Default::default()
            })
        } else {
            Err(result)
        }
    }

    pub fn send_metrics(&self, width: usize, height: usize, pixel_ratio: f64) {
        let event = FlutterWindowMetricsEvent {
            struct_size: std::mem::size_of::<FlutterWindowMetricsEvent>(),
            width,
            height,
            pixel_ratio,
            view_id: IMPLICIT_VIEW_ID,
            ..unsafe { std::mem::zeroed() }
        };

        let result = unsafe {
            flutter_embedder_sys::FlutterEngineSendWindowMetricsEvent(self.handle, &event)
        };

        self.log_result("send window metrics", result);
    }

    pub fn send_view_focus(&self, focused: bool) {
        let event = FlutterViewFocusEvent {
            struct_size: std::mem::size_of::<FlutterViewFocusEvent>(),
            view_id: IMPLICIT_VIEW_ID,
            state: if focused {
                FlutterViewFocusState_kFocused
            } else {
                FlutterViewFocusState_kUnfocused
            },
            direction: FlutterViewFocusDirection_kUndefined,
        };

        let result =
            unsafe { flutter_embedder_sys::FlutterEngineSendViewFocusEvent(self.handle, &event) };
        self.log_result("send view focus", result);
    }

    pub fn schedule_frame(&self) {
        let result = unsafe { flutter_embedder_sys::FlutterEngineScheduleFrame(self.handle) };

        self.log_result("schedule frame", result);
    }

    pub fn handle_cursor_entered(&mut self) {
        self.dispatch_pointer_event(FlutterPointerPhase_kAdd, 0.0, 0.0, false);
    }

    pub fn handle_cursor_left(&mut self) {
        self.dispatch_pointer_event(FlutterPointerPhase_kRemove, 0.0, 0.0, false);
        self.pressed_buttons = 0;
    }

    pub fn handle_cursor_moved(&mut self, x: f64, y: f64) {
        self.cursor_x = x;
        self.cursor_y = y;

        let phase = if self.pointer_down {
            FlutterPointerPhase_kMove
        } else {
            FlutterPointerPhase_kHover
        };

        self.dispatch_pointer_event(phase, 0.0, 0.0, false);
    }

    pub fn handle_mouse_input(&mut self, state: ElementState, button: MouseButton) {
        let Some(mask) = Self::map_mouse_button(button) else {
            return;
        };

        match state {
            ElementState::Pressed => self.pressed_buttons |= mask,
            ElementState::Released => self.pressed_buttons &= !mask,
        }

        let phase = self.phase_from_button_state();
        self.dispatch_pointer_event(phase, 0.0, 0.0, false);
    }

    pub fn handle_mouse_wheel(&mut self, delta: MouseScrollDelta) {
        let (dx, dy) = match delta {
            MouseScrollDelta::LineDelta(x, y) => {
                let scroll_multiplier = 20.0;
                (x as f64 * scroll_multiplier, -y as f64 * scroll_multiplier)
            }
            MouseScrollDelta::PixelDelta(position) => (position.x, -position.y),
        };

        let phase = self.phase_from_button_state();
        self.dispatch_pointer_event(phase, dx, dy, true);
    }

    fn send_pointer_event(&self, event: FlutterPointerEvent) {
        let result =
            unsafe { flutter_embedder_sys::FlutterEngineSendPointerEvent(self.handle, &event, 1) };
        self.log_result("send pointer event", result);
    }

    pub fn send_key_event(&self, event: &FlutterKeyEvent) {
        let result = unsafe {
            flutter_embedder_sys::FlutterEngineSendKeyEvent(
                self.handle,
                event,
                None,
                std::ptr::null_mut(),
            )
        };
        self.log_result("send key event", result);
    }

    pub fn current_time_micros() -> usize {
        unsafe { flutter_embedder_sys::FlutterEngineGetCurrentTime() as usize }
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

    fn dispatch_pointer_event(
        &mut self,
        phase: FlutterPointerPhase,
        scroll_delta_x: f64,
        scroll_delta_y: f64,
        is_scroll: bool,
    ) {
        if !self.pointer_added && phase != FlutterPointerPhase_kAdd {
            self.dispatch_pointer_event(FlutterPointerPhase_kAdd, 0.0, 0.0, false);
        }

        if phase == FlutterPointerPhase_kAdd && self.pointer_added {
            return;
        }

        if phase == FlutterPointerPhase_kRemove && !self.pointer_added {
            return;
        }

        let event = FlutterPointerEvent {
            struct_size: std::mem::size_of::<FlutterPointerEvent>(),
            phase,
            timestamp: Self::current_time_micros(),
            x: self.cursor_x,
            y: self.cursor_y,
            device: 0,
            signal_kind: if is_scroll {
                FlutterPointerSignalKind_kFlutterPointerSignalKindScroll
            } else {
                FlutterPointerSignalKind_kFlutterPointerSignalKindNone
            },
            scroll_delta_x,
            scroll_delta_y,
            device_kind: FlutterPointerDeviceKind_kFlutterPointerDeviceKindMouse,
            buttons: if phase == FlutterPointerPhase_kAdd {
                0
            } else {
                self.pressed_buttons
            },
            pan_x: 0.0,
            pan_y: 0.0,
            scale: 1.0,
            rotation: 0.0,
            view_id: IMPLICIT_VIEW_ID,
            ..Default::default()
        };

        self.send_pointer_event(event);

        if phase == FlutterPointerPhase_kAdd {
            self.pointer_added = true;
        } else if phase == FlutterPointerPhase_kRemove {
            self.pointer_added = false;
            self.pointer_down = false;
            self.pressed_buttons = 0;
        } else if phase == FlutterPointerPhase_kDown {
            self.pointer_down = true;
        } else if phase == FlutterPointerPhase_kUp {
            self.pointer_down = false;
        }
    }

    fn phase_from_button_state(&self) -> FlutterPointerPhase {
        if self.pressed_buttons == 0 {
            if self.pointer_down {
                FlutterPointerPhase_kUp
            } else {
                FlutterPointerPhase_kHover
            }
        } else if self.pointer_down {
            FlutterPointerPhase_kMove
        } else {
            FlutterPointerPhase_kDown
        }
    }

    fn map_mouse_button(button: MouseButton) -> Option<i64> {
        let mapped = match button {
            MouseButton::Left => {
                FlutterPointerMouseButtons_kFlutterPointerButtonMousePrimary as i64
            }
            MouseButton::Right => {
                FlutterPointerMouseButtons_kFlutterPointerButtonMouseSecondary as i64
            }
            MouseButton::Middle => {
                FlutterPointerMouseButtons_kFlutterPointerButtonMouseMiddle as i64
            }
            MouseButton::Back => FlutterPointerMouseButtons_kFlutterPointerButtonMouseBack as i64,
            MouseButton::Forward => {
                FlutterPointerMouseButtons_kFlutterPointerButtonMouseForward as i64
            }
            MouseButton::Other(index) => {
                if !(6..=62).contains(&index) {
                    return None;
                }
                1_i64 << (index - 1)
            }
        };

        Some(mapped)
    }

    fn log_result(&self, action: &str, result: FlutterEngineResult) {
        if result != FlutterEngineResult_kSuccess {
            eprintln!("Flutter engine failed to {action}. error code={result}");
        }
    }
}

impl Drop for Engine {
    fn drop(&mut self) {
        if self.handle.is_null() {
            return;
        }

        let result = unsafe { flutter_embedder_sys::FlutterEngineShutdown(self.handle) };
        if result != FlutterEngineResult_kSuccess {
            eprintln!("Flutter engine shutdown returned error code={result}");
        }

        self.handle = std::ptr::null_mut();
    }
}
