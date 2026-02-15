#!/usr/bin/env bash
set -euo pipefail

target="${1:-.#nma-gapp-rs}"

echo "==> first build: ${target}"
out1="$(nix build --print-out-paths "${target}")"
hash1="$(nix hash path "${out1}")"

echo "==> second build: ${target}"
out2="$(nix build --print-out-paths "${target}")"
hash2="$(nix hash path "${out2}")"

echo "first : ${hash1}"
echo "second: ${hash2}"

if [[ "${hash1}" != "${hash2}" ]]; then
  echo "ERROR: hashes differ"
  exit 1
fi

echo "OK: reproducible output hash"
