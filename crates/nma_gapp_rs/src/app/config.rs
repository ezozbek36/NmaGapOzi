use flutter_embedder_sys::FlutterProjectArgs;
use std::ffi::CString;

pub struct Project {
    pub assets_path: CString,
    pub icu_data_path: CString,
}

// TODO: Use a more robust path discovery than just env!
impl Project {
    pub fn from_env() -> Self {
        let flutter_sdk =
            std::env::var("FLUTTER_ROOT").expect("FLUTTER_ROOT environment variable must be set");

        Self {
            assets_path: CString::new("../../apps/nma_gapp/build/flutter_assets").unwrap(),
            icu_data_path: CString::new(format!(
                "{}/bin/cache/artifacts/engine/linux-x64/icudtl.dat",
                flutter_sdk
            ))
            .unwrap(),
        }
    }

    pub fn as_project_args(&self) -> FlutterProjectArgs {
        FlutterProjectArgs {
            struct_size: std::mem::size_of::<FlutterProjectArgs>(),
            assets_path: self.assets_path.as_ptr(),
            icu_data_path: self.icu_data_path.as_ptr(),
            ..Default::default()
        }
    }
}
