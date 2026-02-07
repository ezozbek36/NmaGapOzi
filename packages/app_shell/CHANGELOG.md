## 0.0.1

Initial release of the config-driven app shell package.

- Added `AppShell` root widget with theme wiring, focus key handling, command palette overlay, and toast overlay integration.
- Added config-based shell layout assembly via `ShellLayoutBuilder` with left/main/right/bottom regions.
- Added slot injection system with `Slot` and `SlotRegistry`.
- Added command infrastructure with `CommandRegistry`, `CommandExecutor`, and command palette controller/overlay.
- Added keybinding infrastructure with `KeybindingManager` and `KeyResolver`.
- Added Riverpod bootstrap provider to sync commands and keybindings from `config_core`.
- Added tests for command execution and keybinding parsing.
