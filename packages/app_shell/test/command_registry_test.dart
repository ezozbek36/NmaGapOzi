import 'package:app_shell/app_shell.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CommandRegistry executes registered command', (tester) async {
    final registry = CommandRegistry();
    var executed = false;
    late BuildContext context;

    registry.register(Command(id: 'test.command', label: 'Test Command', handler: (_) => executed = true));

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    registry.execute('test.command', context);
    expect(executed, isTrue);
  });
}
