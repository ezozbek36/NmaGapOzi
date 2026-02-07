import 'package:app_shell/app_shell.dart';
import 'package:config_core/config_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  testWidgets('Sidebar visibility depends on config', (tester) async {
    final config = DefaultConfig.value.copyWith(
      ui: DefaultConfig.value.ui.copyWith(
        layout: const LayoutConfig(showLeftSidebar: false, showRightSidebar: true, showBottomPanel: false),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [configProvider.overrideWithValue(config)],
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: AppThemeProvider(isDark: false, child: SizedBox(width: 1200, height: 800, child: ShellLayoutBuilder())),
        ),
      ),
    );

    expect(find.byWidgetPredicate((widget) => widget is Slot && widget.slotId == 'left_sidebar'), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Slot && widget.slotId == 'right_sidebar'), findsOneWidget);
  });
}
