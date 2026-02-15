{
  rust-overlay,
  flutterPackage,
}: [
  rust-overlay.overlays.default
  (final: prev: {
    ${flutterPackage} = prev.${flutterPackage}.override {
      supportedTargetFlutterPlatforms = ["linux"];
    };
  })
]
