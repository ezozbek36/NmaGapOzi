use std::env;
use std::path::PathBuf;

fn main() {
    println!("cargo:rerun-if-env-changed=FLUTTER_ENGINE_LIB_PATH");

    let embedder_path =
        std::env::var("FLUTTER_EMBEDDER_PATH").expect("FLUTTER_EMBEDDER_PATH not set");

    let lib_path = env::var("FLUTTER_ENGINE_LIB_PATH")
        .map(PathBuf::from)
        .unwrap_or_else(|_| PathBuf::from(format!("{}/lib", embedder_path)));

    // Link the flutter_engine library.
    // By default use bundled linux-x64-embedder, but allow override.
    println!("cargo:rustc-link-lib=flutter_engine");
    println!("cargo:rustc-link-search=native={}", lib_path.display());
    println!("cargo:rustc-link-arg=-Wl,-rpath,{}", lib_path.display());

    let bindings = bindgen::Builder::default()
        .header("wrapper.h")
        .clang_arg(format!("-I{}/include", embedder_path))
        .generate_comments(false)
        // Ensure we generate Debug and Default traits for those large structs
        .derive_debug(true)
        .derive_default(true)
        // Flutter's ABI requires structs to have a specific size as the first member.
        // This helper ensures we don't accidentally omit them.
        .explicit_padding(true)
        // Use a callback to tell Cargo to rebuild if the header changes
        .parse_callbacks(Box::new(bindgen::CargoCallbacks::new()))
        .generate()
        .expect("Unable to generate bindings");

    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("bindings.rs"))
        .expect("Couldn't write bindings!");
}
