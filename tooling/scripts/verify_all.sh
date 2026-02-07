#!/bin/bash
set -e

echo "Running melos bootstrap..."
melos bootstrap

echo "Formatting generated files..."
dart format .

echo "Running analysis..."
melos run analyze

echo "Running formatting check..."
melos run format

echo "Running package tests..."
melos run test

echo "Running desktop app tests..."
cd apps/desktop_app && flutter test

echo "Verification complete!"
