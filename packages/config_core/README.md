# config_core

The core configuration management package for NmaGapOS.

## Features

- **YAML/JSON based Configuration:** Strongly typed configuration using `json_serializable`, `equatable`, and generated `copyWith` APIs.
- **Layered Loading:** Supports loading configuration from multiple sources, defaulting to YAML.
- **Deep Merging:** Intelligently merges configuration layers.
- **Migration System:** Versioned configuration with automatic migration paths.
- **Validation:** Ensures configuration files adhere to the expected schema.
- **Hot Reload Support:** Notifies the application when configuration changes.

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  config_core:
    path: ../config_core
```

## Usage

```dart
final loader = ConfigLoader(...);
final config = await loader.load();
```

## Generate JSON schema

```bash
dart run tool/generate_schema.dart
```

This writes `app_config.schema.json` in the package root. You can pass a custom output path as the first argument.
