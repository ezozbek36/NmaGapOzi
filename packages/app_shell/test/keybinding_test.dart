import 'package:app_shell/app_shell.dart';
import 'package:config_core/config_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  test('KeyResolver parses Ctrl+K shortcut', () {
    final binding = KeyResolver.parse('ctrl+k', 'command_palette.open');

    expect(binding, isNotNull);
    expect(binding!.commandId, 'command_palette.open');
    expect(binding.control, isTrue);
    expect(binding.key, LogicalKeyboardKey.keyK);
  });

  test('KeyResolver returns null for unsupported shortcut', () {
    final binding = KeyResolver.parse('ctrl+,', 'settings.open');
    expect(binding, isNull);
  });

  testWidgets('Ctrl+K triggers command palette', (tester) async {
    final config = DefaultConfig.value.copyWith(
      input: const InputConfig(
        keybindings: [KeybindingConfig(key: 'ctrl+k', command: 'command_palette.open')],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [configProvider.overrideWithValue(config)],
        child: const MaterialApp(
          home: Scaffold(body: SizedBox(width: 1200, height: 800, child: AppShell())),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(CommandPalette), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();

    expect(find.byType(CommandPalette), findsOneWidget);
  });
}
