import 'package:config_core/config_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'commands/command_palette_controller.dart';
import 'commands/command_registry.dart';
import 'keybindings/key_resolver.dart';
import 'keybindings/keybinding_manager.dart';

final appShellBootstrapProvider = Provider<void>((ref) {
  final config = ref.watch(configProvider);
  final commandRegistry = ref.watch(commandRegistryProvider);
  final keybindingManager = ref.watch(keybindingManagerProvider);
  final commandPalette = ref.watch(commandPaletteControllerProvider.notifier);

  commandRegistry.register(Command(id: 'command_palette.open', label: 'Open Command Palette', handler: (_) => commandPalette.show()));

  final resolvedBindings = <Keybinding>[const Keybinding(commandId: 'command_palette.open', key: LogicalKeyboardKey.keyK, control: true)];

  for (final binding in config.input.keybindings) {
    final resolved = KeyResolver.parse(binding.key, binding.command);
    if (resolved != null) {
      resolvedBindings.add(resolved);
    }
  }

  keybindingManager.replaceBindings(resolvedBindings);
});
