# Nix Flake Guide

This repository now uses a single flake-first setup for Flutter + Rust development and CI.

## Requirements

- Nix `2.19+`
- Flakes enabled (`experimental-features = nix-command flakes`)
- Supported platform: `x86_64-linux`

## Quick Start

```bash
nix develop
```

Then use the existing monorepo workflows:

```bash
melos bootstrap
melos run analyze
melos run test
cargo run --manifest-path crates/nma_gapp_rs/Cargo.toml
```

## Flake Outputs

- `devShells.default`: combined Flutter + Rust shell (local development)
- `devShells.flutter`: Flutter-focused shell
- `devShells.rust`: Rust-focused shell
- `devShells.ci`: non-interactive shell for CI jobs

- `packages.nma-gapp-flutter-linux`: Flutter Linux desktop bundle
- `packages.nma-gapp-rs`: Rust desktop runtime that embeds Flutter
- `packages.flutter-embedder-env`: pinned Flutter embedder headers + engine library

- `checks.flutter-build`: verifies Flutter Linux bundle build
- `checks.rust-build`: verifies Rust build (with `cargo test`)
- `checks.dart-format`: `dart format --set-exit-if-changed .`
- `checks.rust-fmt`: `cargo fmt --check` for both Rust crates
- `checks.rust-clippy`: `cargo clippy` for `nma_gapp_rs`

- `apps.nma-gapp-rs`: runnable Rust embedder binary
- `apps.nma-gapp-flutter`: runnable Flutter Linux app bundle

## Reproducibility Model

- `flake.lock` pins all upstream inputs (`nixpkgs`, `rust-overlay`, etc.)
- Rust dependencies are pinned by `Cargo.lock` in each crate
- Flutter/Dart dependencies are pinned by monorepo `pubspec.lock`
- Flutter embedder artifact is pinned with an explicit SHA-256 in `flake.nix`
- Rust and Flutter toolchains are pinned in the flake:
  - Rust: `1.92.0` via `rust-overlay`
  - Flutter: `flutter338` from pinned `nixpkgs`

## Validation Commands

```bash
nix flake check
nix build .#nma-gapp-rs
nix build .#nma-gapp-flutter-linux
nix run .#nma-gapp-rs
```

## Bit-for-Bit Verification

```bash
out1=$(nix build --print-out-paths .#nma-gapp-rs)
hash1=$(nix hash path "$out1")

out2=$(nix build --print-out-paths .#nma-gapp-rs)
hash2=$(nix hash path "$out2")

test "$hash1" = "$hash2" && echo "reproducible"
```

## Updating Toolchains

- Update flake inputs:

```bash
nix flake update
```

- Update Rust version in `flake.nix` (`rustToolchainVersion`)
- Update Flutter channel/version by changing `flutter338` in `flake.nix`
- Re-run checks:

```bash
nix flake check
```

## Migration Notes

- Old `shell.nix` workflow is deprecated; use `nix develop`
- Previous mutable `flutter config` shell setup is removed
- Build-time Flutter bundle generation inside Rust `build.rs` is disabled under Nix via `FLUTTER_SKIP_BUNDLE_BUILD=1`
- Rust package receives prebuilt Flutter assets + ICU data from `packages.nma-gapp-flutter-linux`

## Troubleshooting

- If Flutter builds fail with dependency resolution errors, verify `pubspec.lock` is up to date and committed
- If bindgen fails, confirm `LIBCLANG_PATH` points to Nix-provided libclang (already set in shell/package)
- If runtime cannot find Flutter engine, run the wrapped binary from `nix run .#nma-gapp-rs` (it exports required env vars)
