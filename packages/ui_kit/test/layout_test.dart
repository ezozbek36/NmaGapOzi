import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

Widget _wrap(Widget child) {
  return AppThemeProvider(
    isDark: true,
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  testWidgets('Panel renders header body and footer', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 500,
          height: 260,
          child: Panel(
            header: const PanelHeader(title: Text('Header')),
            body: const PanelBody(scrollable: false, child: Text('Body')),
            footer: const PanelFooter(child: Text('Footer')),
          ),
        ),
      ),
    );

    expect(find.text('Header'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('Footer'), findsOneWidget);
  });

  testWidgets('ResizableSplit renders both panes', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SizedBox(
          width: 500,
          height: 260,
          child: ResizableSplit(direction: SplitDirection.horizontal, firstChild: Text('Left Pane'), secondChild: Text('Right Pane')),
        ),
      ),
    );

    expect(find.text('Left Pane'), findsOneWidget);
    expect(find.text('Right Pane'), findsOneWidget);
  });

  testWidgets('TabBar updates TabView content on selection', (tester) async {
    var selected = 'one';

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 600,
              height: 280,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      TabItemData(id: 'one', label: 'One', closable: false),
                      TabItemData(id: 'two', label: 'Two', closable: false),
                    ],
                    selectedTabId: selected,
                    onTabSelected: (id) => setState(() => selected = id),
                  ),
                  Expanded(
                    child: TabView(selectedTabId: selected, children: const {'one': Text('First Content'), 'two': Text('Second Content')}),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('First Content'), findsOneWidget);

    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();

    expect(find.text('Second Content'), findsOneWidget);
  });
}
