{
  lib,
  root,
  sourceExcludes,
  flutterEphemeralPrefix,
}:
lib.cleanSourceWith {
  src = root;
  filter = path: type: let
    relPath = lib.removePrefix "${toString root}/" (toString path);
    base = baseNameOf (toString path);
  in
    !(lib.elem base sourceExcludes || lib.hasPrefix flutterEphemeralPrefix relPath);
}
