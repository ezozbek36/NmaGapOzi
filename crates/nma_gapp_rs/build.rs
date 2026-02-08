use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;

fn main() {
    // 1. Define paths
    let manifest_dir = env::var("CARGO_MANIFEST_DIR").unwrap();
    let flutter_root_dir = env::var("FLUTTER_ROOT").unwrap();
    let _flutter_sdk_root = Path::new(&flutter_root_dir);
    let flutter_project_path = Path::new(&manifest_dir).join("../../apps/nma_gapp");
    let _flutter_assets_path = flutter_project_path.join("build/flutter_assets");

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

    // 3. Run 'flutter build bundle'
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

    let lib_path = env::var("FLUTTER_ENGINE_LIB_PATH")
        .map(PathBuf::from)
        .unwrap();

    println!("cargo:rustc-link-arg=-Wl,-rpath,{}", lib_path.display());
}
