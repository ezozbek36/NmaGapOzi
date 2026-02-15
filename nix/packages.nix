{
  pkgs,
  root,
  cleanSrc,
  flutterSdk,
  rustPlatform,
  rustRuntimeLibs,
  embedderEnv,
  flutterEnv,
}: let
  flutterApp = flutterSdk.buildFlutterApplication {
    pname = "nma_gapp";
    version = "1.0.0";
    src = cleanSrc;
    sourceRoot = "source/apps/nma_gapp";
    autoPubspecLock = root + "/pubspec.lock";
    flutterMode = "release";
    targetFlutterPlatform = "linux";
    dontUseCmakeConfigure = true;

    nativeBuildInputs = with pkgs; [
      cmake
      ninja
      pkg-config
    ];

    buildInputs = with pkgs; [
      glib
      gtk3
    ];

    preBuild = ''
      chatCoreDir="../../packages/chat_core"
      chmod -R u+w "$chatCoreDir"
      chmod -R u+w .dart_tool
      mkdir -p "$chatCoreDir/.dart_tool"
      ln -sf ../../pubspec.lock "$chatCoreDir/pubspec.lock"

      jq '
        .packages |= (
          map(select(.name != "nma_gapp" and .name != "chat_core")) +
          [
            {
              "name": "chat_core",
              "rootUri": "../",
              "packageUri": "lib/",
              "languageVersion": "3.10"
            }
          ]
        )
      ' .dart_tool/package_config.json > "$chatCoreDir/.dart_tool/package_config.json"

      appConfigTemp=$(mktemp)
      jq '
        .packages = (.packages | map(
          if .name == "chat_core" then
            .rootUri = "../../../packages/chat_core"
          else
            .
          end
        ))
      ' .dart_tool/package_config.json > "$appConfigTemp"
      cp "$appConfigTemp" .dart_tool/package_config.json
      rm "$appConfigTemp"

      (
        cd "$chatCoreDir"
        buildRunnerUri=$(jq -r '.packages[] | select(.name == "build_runner").rootUri' .dart_tool/package_config.json)
        buildRunnerPath=$(realpath "''${buildRunnerUri#file://}")

        dart \
          --packages=.dart_tool/package_config.json \
          "$buildRunnerPath/bin/build_runner.dart" \
          build \
          --delete-conflicting-outputs
      )
    '';
  };

  flutterAssetsPath = "${flutterApp}/app/nma_gapp/data/flutter_assets";
  flutterIcuDataPath = "${flutterApp}/app/nma_gapp/data/icudtl.dat";

  rustBundleEnv = flutterEnv.withBundlePaths {
    inherit flutterAssetsPath flutterIcuDataPath;
  };

  nmaGappRs = rustPlatform.buildRustPackage (
    {
      pname = "nma_gapp_rs";
      version = "0.1.0";
      src = cleanSrc;
      cargoRoot = "crates/nma_gapp_rs";
      buildAndTestSubdir = "crates/nma_gapp_rs";
      cargoLock.lockFile = root + "/crates/nma_gapp_rs/Cargo.lock";
      dontUseCmakeConfigure = true;
      dontUseNinjaBuild = true;
      dontUseNinjaCheck = true;
      dontUseNinjaInstall = true;

      nativeBuildInputs = with pkgs; [
        clang
        cmake
        llvmPackages.libclang
        makeWrapper
        ninja
        pkg-config
      ];

      buildInputs = rustRuntimeLibs ++ [embedderEnv];

      doCheck = true;

      postInstall = ''
        wrapProgram "$out/bin/nma_gapp_rs" \
          --set-default FLUTTER_ROOT "${rustBundleEnv.FLUTTER_ROOT}" \
          --set-default FLUTTER_EMBEDDER_PATH "${rustBundleEnv.FLUTTER_EMBEDDER_PATH}" \
          --set-default FLUTTER_ENGINE_LIB_PATH "${rustBundleEnv.FLUTTER_ENGINE_LIB_PATH}" \
          --set-default FLUTTER_ASSETS_PATH "${rustBundleEnv.FLUTTER_ASSETS_PATH}" \
          --set-default FLUTTER_ICU_DATA_PATH "${rustBundleEnv.FLUTTER_ICU_DATA_PATH}" \
          --prefix LD_LIBRARY_PATH : "${rustBundleEnv.LD_LIBRARY_PATH}"
      '';
    }
    // rustBundleEnv
  );
in {
  inherit
    flutterApp
    nmaGappRs
    flutterAssetsPath
    flutterIcuDataPath
    ;

  packages = {
    default = nmaGappRs;
    nma-gapp-rs = nmaGappRs;
    nma-gapp-flutter-linux = flutterApp;
    flutter-embedder-env = embedderEnv;
  };
}
