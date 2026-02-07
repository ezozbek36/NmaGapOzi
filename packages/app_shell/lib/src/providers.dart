import 'package:config_core/config_core.dart';
import 'package:flutter/foundation.dart';
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

  final builtInHandlers = <String, CommandHandler>{
    'command_palette.open': (_) => commandPalette.show(),
    'settings.open': (_) => debugPrint('Command not implemented: settings.open'),
  };
  final builtInLabels = <String, String>{'command_palette.open': 'Open Command Palette', 'settings.open': 'Open Settings'};
  final configCommandsById = <String, CommandConfig>{};
  for (final configCommand in config.commands) {
    if (configCommandsById.containsKey(configCommand.id)) {
      debugPrint('Warning: Duplicate command id in config: ${configCommand.id}');
    }
    configCommandsById[configCommand.id] = configCommand;
  }

  final registeredCommandIds = <String>{};

  void registerCommand(String id, String label, CommandHandler handler) {
    commandRegistry.register(Command(id: id, label: label, handler: handler), warnOnOverwrite: false);
    registeredCommandIds.add(id);
  }

  for (final entry in builtInHandlers.entries) {
    registerCommand(entry.key, configCommandsById[entry.key]?.title ?? builtInLabels[entry.key] ?? entry.key, entry.value);
  }

  for (final configCommand in configCommandsById.values) {
    if (registeredCommandIds.contains(configCommand.id)) {
      continue;
    }
    registerCommand(configCommand.id, configCommand.title, (_) => debugPrint('Command not implemented: ${configCommand.id}'));
  }

  final resolvedBindings = <Keybinding>[];

  for (final binding in config.input.keybindings) {
    final resolved = KeyResolver.parse(binding.key, binding.command);
    if (resolved == null) {
      debugPrint('Warning: Unresolved keybinding "${binding.key}" for command "${binding.command}"');
      continue;
    }

    if (!registeredCommandIds.contains(binding.command) && commandRegistry.getCommand(binding.command) == null) {
      debugPrint('Warning: Keybinding "${binding.key}" references unregistered command "${binding.command}"');
      continue;
    }

    resolvedBindings.add(resolved);
  }

  keybindingManager.replaceBindings(resolvedBindings);
});
