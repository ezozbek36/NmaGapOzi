## 0.0.1

- Introduced the `config_core` package with typed configuration schema models for app, UI, layout, input, commands, provider, and debug settings.
- Added `ConfigLoader` with platform-aware config path resolution, YAML loading/saving, and hot-reload support via file watching.
- Added layered config merging (`defaults` + `user config` + `runtime overrides`) with recursive map merge behavior.
- Added config validation and structured validation results for common value/range checks.
- Added migration infrastructure (`ConfigMigrator`, `Migration`, and initial `v1 -> v2` migration scaffold).
- Added Riverpod integration providers (`configLoaderProvider`, `configStreamProvider`, `configProvider`) for consuming live config in the app.
- Added unit tests covering merge behavior, migration flow, validation rules, and loader validation failure scenarios.
