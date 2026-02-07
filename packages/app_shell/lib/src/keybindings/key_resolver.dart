import 'package:flutter/services.dart';
import 'keybinding_manager.dart';

class KeyResolver {
  const KeyResolver._();

  static Keybinding? parse(String rawKey, String commandId) {
    final parts = rawKey.toLowerCase().replaceAll(' ', '').split('+').where((p) => p.isNotEmpty).toList();

    if (parts.isEmpty) return null;

    final keyToken = parts.removeLast();
    final key = _resolveKey(keyToken);
    if (key == null) return null;

    return Keybinding(
      commandId: commandId,
      key: key,
      control: parts.contains('ctrl') || parts.contains('control'),
      shift: parts.contains('shift'),
      alt: parts.contains('alt'),
      meta: parts.contains('meta') || parts.contains('cmd') || parts.contains('command'),
    );
  }

  static LogicalKeyboardKey? _resolveKey(String token) {
    if (token.length == 1) {
      return _letterKeys[token.toLowerCase()];
    }

    switch (token) {
      case 'enter':
        return LogicalKeyboardKey.enter;
      case 'escape':
      case 'esc':
        return LogicalKeyboardKey.escape;
      case 'tab':
        return LogicalKeyboardKey.tab;
      case 'space':
        return LogicalKeyboardKey.space;
      case 'up':
        return LogicalKeyboardKey.arrowUp;
      case 'down':
        return LogicalKeyboardKey.arrowDown;
      case 'left':
        return LogicalKeyboardKey.arrowLeft;
      case 'right':
        return LogicalKeyboardKey.arrowRight;
      default:
        return null;
    }
  }

  static const Map<String, LogicalKeyboardKey> _letterKeys = {
    'a': LogicalKeyboardKey.keyA,
    'b': LogicalKeyboardKey.keyB,
    'c': LogicalKeyboardKey.keyC,
    'd': LogicalKeyboardKey.keyD,
    'e': LogicalKeyboardKey.keyE,
    'f': LogicalKeyboardKey.keyF,
    'g': LogicalKeyboardKey.keyG,
    'h': LogicalKeyboardKey.keyH,
    'i': LogicalKeyboardKey.keyI,
    'j': LogicalKeyboardKey.keyJ,
    'k': LogicalKeyboardKey.keyK,
    'l': LogicalKeyboardKey.keyL,
    'm': LogicalKeyboardKey.keyM,
    'n': LogicalKeyboardKey.keyN,
    'o': LogicalKeyboardKey.keyO,
    'p': LogicalKeyboardKey.keyP,
    'q': LogicalKeyboardKey.keyQ,
    'r': LogicalKeyboardKey.keyR,
    's': LogicalKeyboardKey.keyS,
    't': LogicalKeyboardKey.keyT,
    'u': LogicalKeyboardKey.keyU,
    'v': LogicalKeyboardKey.keyV,
    'w': LogicalKeyboardKey.keyW,
    'x': LogicalKeyboardKey.keyX,
    'y': LogicalKeyboardKey.keyY,
    'z': LogicalKeyboardKey.keyZ,
  };
}
