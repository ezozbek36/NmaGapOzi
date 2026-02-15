{
  pkgs,
  lib,
  flutterSdk,
  embedderEnv,
  rustRuntimeLibs,
}: let
  common = {
    FLUTTER_ROOT = "${flutterSdk}";
    FLUTTER_EMBEDDER_PATH = "${embedderEnv}";
    FLUTTER_ENGINE_LIB_PATH = "${embedderEnv}/lib";
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    LD_LIBRARY_PATH = lib.makeLibraryPath (rustRuntimeLibs ++ [embedderEnv]);
  };
in {
  inherit common;

  withBundlePaths = {
    flutterAssetsPath,
    flutterIcuDataPath,
  }:
    common
    // {
      FLUTTER_ASSETS_PATH = flutterAssetsPath;
      FLUTTER_ICU_DATA_PATH = flutterIcuDataPath;
      FLUTTER_SKIP_BUNDLE_BUILD = "1";
    };
}
