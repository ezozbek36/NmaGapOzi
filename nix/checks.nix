{
  pkgs,
  cleanSrc,
  flutterSdk,
  rustToolchain,
  rustRuntimeLibs,
  embedderEnv,
  flutterEnv,
  flutterApp,
  nmaGappRs,
  flutterAssetsPath,
  flutterIcuDataPath,
}: let
  mkWritableRepoCheck = name: attrs: script:
    pkgs.runCommand name (attrs // {src = cleanSrc;}) ''
      cp -r "$src" repo
      chmod -R +w repo
      cd repo
      ${script}
      touch "$out"
    '';
in {
  flutter-build = flutterApp;
  rust-build = nmaGappRs;

  dart-format = mkWritableRepoCheck "dart-format-check" {nativeBuildInputs = [flutterSdk];} ''
    "${flutterSdk}/bin/dart" format --set-exit-if-changed .
  '';

  rust-fmt = mkWritableRepoCheck "rustfmt-check" {nativeBuildInputs = [rustToolchain];} ''
    cargo fmt --manifest-path crates/flutter-embedder-sys/Cargo.toml --all --check
    cargo fmt --manifest-path crates/nma_gapp_rs/Cargo.toml --all --check
  '';

  rust-clippy =
    mkWritableRepoCheck "rust-clippy-check"
    (
      {
        nativeBuildInputs = with pkgs; [
          clang
          llvmPackages.libclang
          pkg-config
          rustToolchain
        ];

        buildInputs = rustRuntimeLibs ++ [embedderEnv];
      }
      // flutterEnv.withBundlePaths {
        inherit flutterAssetsPath flutterIcuDataPath;
      }
    )
    ''
      export CARGO_HOME="$PWD/.cargo"
      export CARGO_TARGET_DIR="$PWD/.cargo-target"
      cargo clippy --manifest-path crates/nma_gapp_rs/Cargo.toml --all-targets -- -D warnings
    '';
}
