flake: {
  pkgs,
  flutterSdk,
  embedderEnv,
  rustToolchain,
  ...
}: let
  runtimeLibs = with pkgs; [
    libglvnd
    libthai
    libdatrie
    xorg.libXdmcp
    pcre
    libepoxy
    util-linux
    libselinux
    libsepol
  ];

  buildDeps = with pkgs; [
    at-spi2-atk
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    pango
    sysprof
  ];
in
  pkgs.mkShellNoCC rec {
    nativeBuildInputs = with pkgs; [
      cmake
      ninja
      pkg-config
    ];

    buildInputs = buildDeps ++ runtimeLibs;

    packages = with pkgs; [
      nixd
      statix
      deadnix
      alejandra
      clang-tools
      rustToolchain

      melos
      flutterSdk
    ];

    FLUTTER_ROOT = "${flutterSdk}";
    FLUTTER_EMBEDDER_PATH = "${embedderEnv}";
    FLUTTER_ENGINE_LIB_PATH = "${embedderEnv}/lib";
    DART_ROOT = "${FLUTTER_ROOT}/bin/cache/dart-sdk";

    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath (buildDeps ++ runtimeLibs ++ [embedderEnv])}";

    shellHook = ''
      flutter config --no-analytics > /dev/null
      flutter config --enable-linux-desktop > /dev/null
      flutter config --no-enable-web > /dev/null
      flutter config --no-enable-android > /dev/null
      flutter config --no-enable-ios > /dev/null
      flutter config --enable-macos-desktop > /dev/null
      flutter config --enable-windows-desktop > /dev/null
      flutter config --enable-native-assets > /dev/null
    '';
  }
