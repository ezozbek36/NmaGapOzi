mod app;
mod callbacks;
mod gl_context;

use winit::{self, event_loop::EventLoop};

use crate::app::App;

fn main() {
    let event_loop = EventLoop::new().unwrap();
    event_loop.set_control_flow(winit::event_loop::ControlFlow::Wait);
    event_loop.run_app(&mut App::default()).unwrap();
}
