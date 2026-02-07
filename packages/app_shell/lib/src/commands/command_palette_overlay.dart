import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart' as ui;
import 'command_registry.dart';
import 'command_palette_controller.dart';

class CommandPaletteOverlay extends ConsumerWidget {
  const CommandPaletteOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(commandPaletteControllerProvider);

    if (!isVisible) {
      return const SizedBox.shrink();
    }

    final commandRegistry = ref.watch(commandRegistryProvider);
    final commands = commandRegistry.allCommands;

    return ui.CommandPalette(
      commands: commands
          .map(
            (cmd) => ui.Command(
              id: cmd.id,
              icon: cmd.icon,
              label: cmd.label,
              onExecute: () {
                ref.read(commandPaletteControllerProvider.notifier).hide();
                cmd.handler(context);
              },
            ),
          )
          .toList(),
      onClose: () {
        ref.read(commandPaletteControllerProvider.notifier).hide();
      },
    );
  }
}
