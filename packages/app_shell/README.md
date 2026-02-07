`app_shell` is a config-driven Flutter application shell package for composing a desktop-style UI layout.

## Features

- Builds shell layout from `config_core` (`left_sidebar`, `main_content`, `right_sidebar`, `bottom_panel`).
- Provides a typed slot system (`Slot`, `SlotRegistry`) for runtime content injection.
- Includes a command system (`CommandRegistry`, `CommandExecutor`) and command palette wiring.
- Includes global keybinding support with configurable bindings from `InputConfig`.
- Reacts to config updates via Riverpod providers for shell hot-reload behavior.

## Package layout

Core API surface in `0.0.1`:

- `AppShell`: root shell widget that wires theme, layout, key handling, command palette, and toast overlay.
- `ShellLayoutBuilder`: composes left/main/right/bottom regions from `config.ui.layout`.
- `Slot` + `SlotRegistry`: runtime slot injection for `left_sidebar`, `main_content`, `right_sidebar`, and `bottom_panel`.
- `CommandRegistry` + `CommandExecutor`: command registration and execution by command id.
- `CommandPaletteController` + `CommandPaletteOverlay`: command palette visibility and rendering bridge.
- `KeybindingManager` + `KeyResolver`: key event matching and binding parsing from `InputConfig`.

## Getting started

Add `app_shell` to your workspace dependencies and ensure `config_core` providers are available.

Main dependencies used by this package:

- `flutter`
- `flutter_riverpod`
- `config_core`
- `ui_kit`

## Usage

```dart
import 'package:app_shell/app_shell.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: AppShell(),
      ),
    );
  }
}
```

Register slot content from your integration layer:

```dart
ref.read(slotRegistryProvider.notifier).register('left_sidebar', (context) => const SizedBox());
ref.read(slotRegistryProvider.notifier).register('main_content', (context) => const SizedBox());
ref.read(slotRegistryProvider.notifier).register('right_sidebar', (context) => const SizedBox());
ref.read(slotRegistryProvider.notifier).register('bottom_panel', (context) => const SizedBox());
```

Register custom commands:

```dart
ref.read(commandRegistryProvider).register(
  Command(
    id: 'example.hello',
    label: 'Say Hello',
    handler: (_) {
      // command action
    },
  ),
);
```

Open command palette from your own command/keybinding:

```dart
ref.read(commandPaletteControllerProvider.notifier).show();
```

## Notes

- Default binding: `Ctrl+K` -> `command_palette.open`.
- `KeyResolver` currently supports alpha keys (`A-Z`) and common keys such as `enter`, `escape`, `tab`, `space`, and arrows.
- Theme mode is derived from `config.ui.theme.mode` (`dark` uses the dark theme path; others use light path in this phase).

## Version

Current initial package version: `0.0.1`.
