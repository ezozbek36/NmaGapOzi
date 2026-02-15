{
  description = "Hermetic Nix flake for the NmaGapOS Flutter/Rust monorepo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
    ...
  }: let
    config = import ./nix/config.nix;
  in
    flake-utils.lib.eachSystem config.supportedSystems (
      system:
        import ./nix/per-system.nix {
          inherit
            system
            config
            nixpkgs
            flake-utils
            rust-overlay
            ;
          root = ./.;
        }
    );
}
