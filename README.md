# NmaGapOZi

NmaGapOZi is a config-first, modular chat application framework built with Flutter and Dart. It emphasizes flexibility through a decoupled architecture and a robust configuration system.

## Project Overview

Phase 0 Goals:
- **Config-first Architecture:** Centralized YAML configuration for UI, behavior, and providers.
- **Mock Provider:** A deterministic mock provider for rapid development and testing without a real backend.
- **Modular Monorepo:** Clearly separated packages for core logic, UI components, and API definitions.

## Quick Start

<details>
<summary><b>Prerequisites</b></summary>

This project uses [Nix Flakes](https://nixos.wiki/wiki/Flakes) to manage the development environment. 

If you have Nix installed with flakes enabled, you can simply run:
```bash
nix develop
```
This will provide the Flutter SDK, Dart, Melos, and all necessary dependencies.

Alternatively, you can manually install:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version recommended)
- [Melos](https://melos.invertase.dev/getting-started) (`dart pub global activate melos`)
</details>

### Setup

1.  **Bootstrap the monorepo:**
    ```bash
    melos bootstrap
    ```

2.  **Run the desktop application:**
    ```bash
    cd apps/nma_gapp
    flutter run -d linux
    ```

## Architecture

The project is organized into several packages:

- `packages/config_core`: Handles loading, merging, and validating the application configuration.
- `packages/chat_core`: Contains the core business logic, including BLoCs and use cases for chat functionality.
- `packages/provider_api`: Defines the interfaces and data models for chat providers.
- `packages/provider_mock`: A deterministic mock implementation of the chat provider.
- `packages/ui_kit`: A collection of reusable UI components and theme definitions.
- `packages/app_shell`: Manages the overall application layout, command execution, and keybindings.
- `apps/nma_gapp`: The main Flutter desktop application that wires everything together.

## Configuration

NmaGapOZi uses a YAML configuration file to control many aspects of the application.

- **Location:** By default, the application looks for `config.yaml` in the user's config directory (e.g., `~/.config/nmagapozi/config.yaml` on Linux).
- **Example:** See `config.example.yaml` in the root directory for a commented example.
- **Hot Reload:** If `debug.enable_hot_reload_config` is set to `true`, the application will reload most settings when the configuration file is saved.

## Mock Provider

The mock provider allows you to simulate various backend behaviors.

- **Seed:** Change `provider.settings.seed` in your config to get a different set of generated data.
- **Latency:** Adjust `latency_min_ms` and `latency_max_ms` to simulate network delay.
- **Errors:** Set `failure_rate` (0.0 to 1.0) to simulate intermittent API failures.

## Keybindings

Default keybindings:
- `Ctrl + P`: Open Command Palette
- `Esc`: Close Command Palette / Go back

## Development

### Verification Script

Run the following command to analyze, format, and test all packages:

```bash
./tooling/scripts/verify_all.sh
```
