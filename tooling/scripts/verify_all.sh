#!/bin/bash
set -e

echo "Running melos bootstrap..."
melos bootstrap

echo "Checking dependency hygiene..."
dart run tooling/scripts/check_dependency_hygiene.dart

echo "Formatting files..."
melos run format

echo "Running analysis..."
melos run analyze

echo "Running package tests..."
melos run test

echo "Running desktop app tests..."
cd apps/nma_gapp && flutter test

echo "Verification complete!"
