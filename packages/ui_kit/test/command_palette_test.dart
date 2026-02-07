import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

Widget _wrap(Widget child) {
  return AppThemeProvider(
    isDark: true,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  testWidgets('CommandPalette filters commands from search input', (tester) async {
    await tester.pumpWidget(
      _wrap(
        CommandPalette(
          commands: [
            Command(id: 'open', label: 'Open File', onExecute: () {}),
            Command(id: 'close', label: 'Close Window', onExecute: () {}),
          ],
          onClose: () {},
        ),
      ),
    );

    expect(find.text('Open File'), findsOneWidget);
    expect(find.text('Close Window'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'open');
    await tester.pumpAndSettle();

    expect(find.text('Open File'), findsOneWidget);
    expect(find.text('Close Window'), findsNothing);
  });

  testWidgets('CommandPalette executes selected command on tap and closes', (tester) async {
    var executed = false;
    var closed = false;

    await tester.pumpWidget(
      _wrap(
        CommandPalette(
          commands: [Command(id: 'refresh', label: 'Refresh', onExecute: () => executed = true)],
          onClose: () => closed = true,
        ),
      ),
    );

    await tester.tap(find.text('Refresh'));
    await tester.pumpAndSettle();

    expect(executed, isTrue);
    expect(closed, isTrue);
  });
}
