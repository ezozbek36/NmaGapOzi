import 'package:config_core/config_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'commands/command_palette_overlay.dart';
import 'keybindings/keybinding_manager.dart';
import 'layout/layout_builder.dart';
import 'providers.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final keybindingManager = ref.watch(keybindingManagerProvider);
    ref.watch(appShellBootstrapProvider);

    return AppThemeProvider(
      isDark: config.ui.theme.mode == 'dark',
      child: FocusScope(
        autofocus: true,
        onKeyEvent: (node, event) => keybindingManager.handleKeyWithContext(node, event, context),
        child: ToastOverlay(child: const Stack(children: [ShellLayoutBuilder(), CommandPaletteOverlay()])),
      ),
    );
  }
}
