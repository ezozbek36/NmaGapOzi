#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
app_path="${1:-apps/nma_gapp}"
app_dir="${repo_root}/${app_path}"

if [[ ! -f "${app_dir}/linux/CMakeLists.txt" ]]; then
  echo "Could not find Flutter Linux CMake project at: ${app_dir}/linux/CMakeLists.txt" >&2
  echo "Usage: tooling/scripts/flutter_linux_lsp.sh [app-relative-path]" >&2
  exit 1
fi

cmake \
  -S "${app_dir}/linux" \
  -B "${app_dir}/build/linux/lsp" \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

echo "Generated compile database: ${app_dir}/build/linux/lsp/compile_commands.json"
