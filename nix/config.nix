{
  supportedSystems = ["x86_64-linux"];

  rustToolchainVersion = "1.92.0";
  flutterPackage = "flutter338";
  flutterEmbedderSha256 = "sha256-JBLnFWcWk/dke5twqIHzE5SuG9eR0wzWzB/4a6ACEow=";

  sourceExcludes = [
    ".dart_tool"
    ".direnv"
    ".git"
    ".idea"
    "build"
    "target"
  ];

  flutterEphemeralPrefix = "apps/nma_gapp/linux/flutter/ephemeral";
}
