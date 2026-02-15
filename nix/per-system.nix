{
  system,
  root,
  config,
  nixpkgs,
  flake-utils,
  rust-overlay,
}: let
  overlays = import ./overlays.nix {
    inherit rust-overlay;
    flutterPackage = config.flutterPackage;
  };

  pkgs = import nixpkgs {
    inherit system overlays;
  };

  lib = pkgs.lib;

  cleanSrc = import ./clean-src.nix {
    inherit lib root;
    sourceExcludes = config.sourceExcludes;
    flutterEphemeralPrefix = config.flutterEphemeralPrefix;
  };

  toolchains = import ./toolchains.nix {
    inherit pkgs;
    rustToolchainVersion = config.rustToolchainVersion;
  };

  flutterSdk = pkgs.${config.flutterPackage};

  flutterArtifacts = import ./flutter-artifacts.nix {
    inherit pkgs lib flutterSdk;
    flutterEmbedderSha256 = config.flutterEmbedderSha256;
  };

  rustRuntimeLibs = import ./runtime-libs.nix {inherit pkgs;};

  flutterEnv = import ./flutter-env.nix {
    inherit
      pkgs
      lib
      flutterSdk
      rustRuntimeLibs
      ;
    inherit (flutterArtifacts) embedderEnv;
  };

  packagesContext = import ./packages.nix {
    inherit
      pkgs
      root
      cleanSrc
      flutterSdk
      rustRuntimeLibs
      ;
    inherit flutterEnv;
    inherit (toolchains) rustPlatform;
    inherit (flutterArtifacts) embedderEnv;
  };

  checks = import ./checks.nix {
    inherit
      pkgs
      cleanSrc
      flutterSdk
      rustRuntimeLibs
      ;
    inherit flutterEnv;
    inherit (toolchains) rustToolchain;
    inherit (flutterArtifacts) embedderEnv;
    inherit
      (packagesContext)
      flutterApp
      nmaGappRs
      flutterAssetsPath
      flutterIcuDataPath
      ;
  };

  apps = import ./apps.nix {
    inherit flake-utils;
    inherit (packagesContext) nmaGappRs flutterApp;
  };

  devShells = import ./dev-shells.nix {
    inherit
      pkgs
      flutterSdk
      rustRuntimeLibs
      ;
    inherit flutterEnv;
    inherit (toolchains) rustToolchain;
    inherit (flutterArtifacts) embedderEnv;
  };
in {
  formatter = pkgs.alejandra;
  inherit checks apps devShells;
  packages = packagesContext.packages;

  legacyPackages = {
    inherit (toolchains) rustToolchainVersion;
    inherit (flutterArtifacts) flutterEngineVersion;
  };
}
