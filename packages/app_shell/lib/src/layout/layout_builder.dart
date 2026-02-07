import 'package:config_core/config_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/ui_kit.dart';
import 'slots.dart';

class ShellLayoutBuilder extends ConsumerWidget {
  const ShellLayoutBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final layoutConfig = config.ui.layout;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final totalHeight = constraints.maxHeight;

        Widget center = const Slot(slotId: 'main_content');

        if (layoutConfig.showBottomPanel) {
          final mainHeightFraction = _fractionFromPixels(
            total: totalHeight,
            firstPixels: totalHeight - layoutConfig.bottomPanelHeight,
            fallback: 0.8,
          );
          center = ResizableSplit(
            direction: SplitDirection.vertical,
            firstChild: center,
            secondChild: const Slot(slotId: 'bottom_panel'),
            initialSize: mainHeightFraction,
          );
        }

        if (layoutConfig.showRightSidebar) {
          final widthWithoutLeft = totalWidth - (layoutConfig.showLeftSidebar ? layoutConfig.leftSidebarWidth : 0);
          final mainWidthFraction = _fractionFromPixels(
            total: widthWithoutLeft,
            firstPixels: widthWithoutLeft - layoutConfig.rightSidebarWidth,
            fallback: 0.8,
          );
          center = ResizableSplit(
            direction: SplitDirection.horizontal,
            firstChild: center,
            secondChild: const Slot(slotId: 'right_sidebar'),
            initialSize: mainWidthFraction,
          );
        }

        if (layoutConfig.showLeftSidebar) {
          final leftWidthFraction = _fractionFromPixels(total: totalWidth, firstPixels: layoutConfig.leftSidebarWidth, fallback: 0.2);
          center = ResizableSplit(
            direction: SplitDirection.horizontal,
            firstChild: const Slot(slotId: 'left_sidebar'),
            secondChild: center,
            initialSize: leftWidthFraction,
          );
        }

        return center;
      },
    );
  }

  double _fractionFromPixels({required double total, required double firstPixels, required double fallback}) {
    if (!total.isFinite || total <= 0) {
      return fallback;
    }

    final fraction = firstPixels / total;
    if (!fraction.isFinite) {
      return fallback;
    }

    return fraction.clamp(0.1, 0.9);
  }
}
