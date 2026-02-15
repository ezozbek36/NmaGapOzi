{
  pkgs,
  lib,
  flutterSdk,
  flutterEmbedderSha256,
}: let
  flutterEngineVersion = lib.removeSuffix "\n" (
    builtins.readFile "${flutterSdk}/bin/internal/engine.version"
  );

  flutterEmbedder = pkgs.fetchzip {
    url = "https://storage.googleapis.com/flutter_infra_release/flutter/${flutterEngineVersion}/linux-x64/linux-x64-embedder.zip";
    extension = "zip";
    stripRoot = false;
    sha256 = flutterEmbedderSha256;
  };

  embedderEnv = pkgs.runCommand "flutter-embedder-env" {} ''
    mkdir -p "$out/include" "$out/lib"
    ln -s "${flutterEmbedder}/flutter_embedder.h" "$out/include/"
    ln -s "${flutterEmbedder}/libflutter_engine.so" "$out/lib/"
  '';
in {
  inherit flutterEngineVersion flutterEmbedder embedderEnv;
}
