{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    fenix,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem = {
        lib,
        pkgs,
        system,
        ...
      }: let
        flutterSdk = pkgs.flutter.override {
          supportedTargetFlutterPlatforms = [
            "universal"
            "linux"
          ];
        };

        engineVersion = lib.strings.removeSuffix "\n" (builtins.readFile "${flutterSdk}/bin/internal/engine.version");

        flutterEmbedder = pkgs.fetchzip {
          url = "https://storage.googleapis.com/flutter_infra_release/flutter/${engineVersion}/linux-x64/linux-x64-embedder";
          extension = "zip";
          stripRoot = false;
          sha256 = "sha256-JBLnFWcWk/dke5twqIHzE5SuG9eR0wzWzB/4a6ACEow=";
        };

        embedderEnv = pkgs.runCommand "flutter-embedder-env" {} ''
          mkdir -p $out/lib $out/include
          ln -s ${flutterEmbedder}/libflutter_engine.so $out/lib/
          ln -s ${flutterEmbedder}/flutter_embedder.h $out/include/
        '';
      in {
        formatter = pkgs.alejandra;

        devShells.default = import ./shell.nix self {
          inherit pkgs embedderEnv flutterSdk;
          rustToolchain = fenix.packages.${system}.complete.toolchain;
        };
      };
    };
}
