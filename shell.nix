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
      flutter config --no-analytics
      flutter config --enable-linux-desktop
      flutter config --no-enable-web
      flutter config --no-enable-android
      flutter config --no-enable-ios
      flutter config --enable-macos-desktop
      flutter config --enable-windows-desktop
      flutter config --enable-native-assets
    '';
  }
