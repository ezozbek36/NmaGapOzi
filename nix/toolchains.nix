{ pkgs, rustToolchainVersion }:
let
  rustToolchain = pkgs.rust-bin.stable.${rustToolchainVersion}.default.override {
    extensions = [
      "clippy"
      "rust-src"
      "rustfmt"
    ];
  };
in
{
  inherit rustToolchainVersion rustToolchain;

  rustPlatform = pkgs.makeRustPlatform {
    cargo = rustToolchain;
    rustc = rustToolchain;
  };
}
