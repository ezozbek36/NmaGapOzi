flake: {pkgs, ...}: let
  flutter = pkgs.flutter.override {
    supportedTargetFlutterPlatforms = [
      "universal"
      "linux"
    ];
  };
in
  pkgs.mkShellNoCC rec {
    packages = with pkgs; [
      nixd
      statix
      deadnix
      alejandra

      melos
      flutter
    ];

    FLUTTER_ROOT = "${flutter}";
    DART_ROOT = "${FLUTTER_ROOT}/bin/cache/dart-sdk";

    shellHook = ''
      flutter config --no-analytics >/dev/null 2>&1 || true
      flutter config --enable-linux-desktop >/dev/null 2>&1 || true
      flutter config --no-enable-web >/dev/null 2>&1 || true
      flutter config --no-enable-android >/dev/null 2>&1 || true
      flutter config --no-enable-ios >/dev/null 2>&1 || true
      flutter config --enable-macos-desktop >/dev/null 2>&1 || true
      flutter config --enable-windows-desktop >/dev/null 2>&1 || true
      flutter config --enable-native-assets >/dev/null 2>&1 || true
    '';
  }
