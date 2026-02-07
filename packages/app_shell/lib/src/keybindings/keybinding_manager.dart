import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../commands/command_registry.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final keybindingManagerProvider = Provider((ref) {
  final commandRegistry = ref.watch(commandRegistryProvider);
  return KeybindingManager(commandRegistry);
});

class Keybinding {
  final String commandId;
  final LogicalKeyboardKey key;
  final bool control;
  final bool shift;
  final bool alt;
  final bool meta;

  const Keybinding({
    required this.commandId,
    required this.key,
    this.control = false,
    this.shift = false,
    this.alt = false,
    this.meta = false,
  });

  bool matches(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final keyboard = HardwareKeyboard.instance;

    return event.logicalKey == key &&
        keyboard.isControlPressed == control &&
        keyboard.isShiftPressed == shift &&
        keyboard.isAltPressed == alt &&
        keyboard.isMetaPressed == meta;
  }
}

class KeybindingManager {
  final CommandRegistry _commandRegistry;
  final List<Keybinding> _bindings = [];

  KeybindingManager(this._commandRegistry);

  void register(Keybinding binding) {
    _bindings.add(binding);
  }

  void unregister(String commandId) {
    _bindings.removeWhere((b) => b.commandId == commandId);
  }

  void replaceBindings(List<Keybinding> bindings) {
    _bindings
      ..clear()
      ..addAll(bindings);
  }

  KeyEventResult handleKeyWithContext(FocusNode node, KeyEvent event, BuildContext context) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    for (final binding in _bindings) {
      if (binding.matches(event)) {
        final command = _commandRegistry.getCommand(binding.commandId);
        if (command != null) {
          command.handler(context);
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }
}
