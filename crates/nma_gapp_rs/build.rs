use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;

fn main() {
    println!("cargo:rerun-if-env-changed=FLUTTER_SKIP_BUNDLE_BUILD");

    // 1. Define paths
    let manifest_dir = env::var("CARGO_MANIFEST_DIR").unwrap();
    let flutter_project_path = Path::new(&manifest_dir).join("../../apps/nma_gapp");

    let skip_flutter_bundle = env::var("FLUTTER_SKIP_BUNDLE_BUILD")
        .ok()
        .is_some_and(|value| matches!(value.as_str(), "1" | "true" | "TRUE" | "yes" | "YES"));

    // 2. Tell Cargo to rerun this script if Dart files change
    // This prevents "infinite rebuilding" and only builds when necessary.
    println!(
        "cargo:rerun-if-changed={}/lib",
        flutter_project_path.display()
    );
    println!(
        "cargo:rerun-if-changed={}/pubspec.yaml",
        flutter_project_path.display()
    );

    // 3. Run 'flutter build bundle' unless disabled for Rust-only iteration.
    if skip_flutter_bundle {
        println!(
            "cargo:warning=Skipping Flutter bundle build because FLUTTER_SKIP_BUNDLE_BUILD is set"
        );
    } else {
        println!("cargo:warning=Building Flutter bundle...");

        let status = Command::new("flutter")
            .current_dir(&flutter_project_path)
            .arg("build")
            .arg("bundle")
            .status()
            .expect("Failed to run flutter build bundle");

        if !status.success() {
            panic!("Flutter build failed!");
        }
    }

    // NOTE: Adjust 'linux-x64' if you cross-compile or run on Mac/Windows
    // let icu_src = flutter_sdk_root.join("bin/cache/artifacts/engine/linux-x64/icudtl.dat");
    // let icu_dest = flutter_assets_path.join("icudtl.dat");

    // if icu_src.exists() {
    //     fs::copy(&icu_src, &icu_dest).expect("Failed to copy icudtl.dat");
    //     println!("cargo:warning=Copied icudtl.dat to assets");
    // } else {
    //     println!(
    //         "cargo:warning=Could not find icudtl.dat at {:?}. Please copy it manually.",
    //         icu_src
    //     );
    // }

    println!("cargo:rerun-if-env-changed=FLUTTER_ENGINE_LIB_PATH");
    println!("cargo:rerun-if-env-changed=FLUTTER_ASSETS_PATH");
    println!("cargo:rerun-if-env-changed=FLUTTER_ICU_DATA_PATH");
    println!("cargo:rerun-if-env-changed=FLUTTER_PERSISTENT_CACHE_PATH");
    println!("cargo:rerun-if-env-changed=FLUTTER_PERSISTENT_CACHE_READ_ONLY");
    println!("cargo:rerun-if-env-changed=FLUTTER_ENGINE_SWITCHES");

    let lib_path = env::var("FLUTTER_ENGINE_LIB_PATH")
        .map(PathBuf::from)
        .unwrap();

    println!("cargo:rustc-link-arg=-Wl,-rpath,{}", lib_path.display());
}
