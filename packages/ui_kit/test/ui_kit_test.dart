import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  test('ui_kit barrel exports can be referenced', () {
    const colors = AppColors.dark;
    final split = SplitController();
    const tab = TabItemData(id: 'home', label: 'Home');
    final cmd = Command(id: 'refresh', label: 'Refresh', onExecute: () {});

    expect(colors.background, isNotNull);
    expect(split.size, 0.5);
    expect(tab.label, 'Home');
    expect(cmd.id, 'refresh');
  });
}
