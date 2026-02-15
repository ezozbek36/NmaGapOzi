#!/usr/bin/env bash
set -euo pipefail

echo "==> nix flake check"
nix flake check

echo "==> build Rust runtime"
nix build .#nma-gapp-rs

echo "==> build Flutter Linux bundle"
nix build .#nma-gapp-flutter-linux

echo "==> done"
