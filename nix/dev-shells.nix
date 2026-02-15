{
  pkgs,
  flutterSdk,
  rustToolchain,
  rustRuntimeLibs,
  embedderEnv,
  flutterEnv,
}: let
  commonDevPackages = with pkgs; [
    alejandra
    clang
    clang-tools
    cmake
    deadnix
    melos
    nixd
    pre-commit
    statix
  ];

  flutterDevPackages = [flutterSdk];
  rustDevPackages = [
    rustToolchain
    pkgs.rust-analyzer
  ];

  commonDevInputs =
    rustRuntimeLibs
    ++ [
      embedderEnv
      pkgs.llvmPackages.libclang
    ];

  commonDevEnv = flutterEnv.common;

  flutterShellHook = ''
    REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    export FLUTTER_ASSETS_PATH="$REPO_ROOT/apps/nma_gapp/build/flutter_assets"
    export FLUTTER_ICU_DATA_PATH="$FLUTTER_ROOT/bin/cache/artifacts/engine/linux-x64/icudtl.dat"
  '';

  mkDevShell = {
    extraPackages ? [],
    withFlutterRuntimePaths ? true,
  }:
    pkgs.mkShell (
      commonDevEnv
      // {
        packages = commonDevPackages ++ extraPackages;
        buildInputs = commonDevInputs;
      }
      // (
        if withFlutterRuntimePaths
        then {shellHook = flutterShellHook;}
        else {}
      )
    );
in {
  flutter = mkDevShell {extraPackages = flutterDevPackages;};
  rust = mkDevShell {extraPackages = rustDevPackages;};
  default = mkDevShell {extraPackages = flutterDevPackages ++ rustDevPackages;};

  ci = mkDevShell {
    extraPackages = flutterDevPackages ++ rustDevPackages;
    withFlutterRuntimePaths = false;
  };
}
