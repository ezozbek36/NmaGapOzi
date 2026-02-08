use flutter_embedder_sys::FlutterProjectArgs;
use std::{
    env,
    ffi::{c_void, CStr, CString},
    os::raw::c_char,
    path::PathBuf,
};

pub struct Project {
    pub assets_path: CString,
    pub icu_data_path: CString,
    pub persistent_cache_path: Option<CString>,
    pub is_persistent_cache_read_only: bool,
    pub _engine_switches: Vec<CString>,
    pub engine_switch_ptrs: Vec<*const c_char>,
}

impl Project {
    pub fn from_env() -> Self {
        let assets_path = env::var("FLUTTER_ASSETS_PATH")
            .map(PathBuf::from)
            .expect("FLUTTER_ASSETS_PATH must be set");

        let icu_data_path = env::var("FLUTTER_ICU_DATA_PATH")
            .map(PathBuf::from)
            .unwrap_or_else(|_| {
                let flutter_sdk = env::var("FLUTTER_ROOT")
                    .expect("FLUTTER_ROOT must be set when FLUTTER_ICU_DATA_PATH is not provided");
                PathBuf::from(format!(
                    "{}/bin/cache/artifacts/engine/linux-x64/icudtl.dat",
                    flutter_sdk
                ))
            });

        let persistent_cache_path = env::var("FLUTTER_PERSISTENT_CACHE_PATH")
            .ok()
            .map(PathBuf::from)
            .map(Self::path_to_cstring);

        let is_persistent_cache_read_only = env::var("FLUTTER_PERSISTENT_CACHE_READ_ONLY")
            .ok()
            .is_some_and(|v| matches!(v.as_str(), "1" | "true" | "TRUE" | "yes" | "YES"));

        let engine_switches = Self::parse_engine_switches();
        let engine_switch_ptrs = engine_switches.iter().map(|arg| arg.as_ptr()).collect();

        Self {
            assets_path: Self::path_to_cstring(assets_path),
            icu_data_path: Self::path_to_cstring(icu_data_path),
            persistent_cache_path,
            is_persistent_cache_read_only,
            _engine_switches: engine_switches,
            engine_switch_ptrs,
        }
    }

    pub fn as_project_args(&self) -> FlutterProjectArgs {
        let (command_line_argc, command_line_argv) = if self.engine_switch_ptrs.is_empty() {
            (0, std::ptr::null())
        } else {
            (
                self.engine_switch_ptrs.len() as i32,
                self.engine_switch_ptrs.as_ptr(),
            )
        };

        FlutterProjectArgs {
            struct_size: std::mem::size_of::<FlutterProjectArgs>(),
            assets_path: self.assets_path.as_ptr(),
            icu_data_path: self.icu_data_path.as_ptr(),
            command_line_argc,
            command_line_argv,
            persistent_cache_path: self
                .persistent_cache_path
                .as_ref()
                .map_or(std::ptr::null(), |p| p.as_ptr()),
            is_persistent_cache_read_only: self.is_persistent_cache_read_only,
            log_message_callback: Some(log_message_callback),
            shutdown_dart_vm_when_done: true,
            ..Default::default()
        }
    }

    fn parse_engine_switches() -> Vec<CString> {
        let Some(raw_switches) = env::var("FLUTTER_ENGINE_SWITCHES").ok() else {
            return Vec::new();
        };

        let parsed_switches: Vec<CString> = shlex::split(&raw_switches)
            .unwrap_or_default()
            .into_iter()
            .map(|arg| CString::new(arg).expect("Engine switches cannot contain NUL bytes"))
            .collect();

        if parsed_switches.is_empty() {
            return Vec::new();
        }

        let mut with_program_name = Vec::with_capacity(parsed_switches.len() + 1);
        with_program_name.push(CString::new("nma_gapp_rs").unwrap());
        with_program_name.extend(parsed_switches);
        with_program_name
    }

    fn path_to_cstring(path: PathBuf) -> CString {
        CString::new(path.to_string_lossy().into_owned())
            .expect("Resolved path cannot contain NUL bytes")
    }
}

extern "C" fn log_message_callback(
    tag: *const c_char,
    message: *const c_char,
    _user_data: *mut c_void,
) {
    let tag = unsafe { CStr::from_ptr(tag) };
    let message = unsafe { CStr::from_ptr(message) };

    println!("[{}] {}", tag.to_str().unwrap(), message.to_str().unwrap());
}
