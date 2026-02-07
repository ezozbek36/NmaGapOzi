import 'package:config_core/config_core.dart';
import 'package:test/test.dart';

void main() {
  group('YamlConfigParser', () {
    test('stringify() emits YAML and supports round-trip parsing', () {
      const input = '''
configVersion: 1
ui:
  theme:
    mode: system
    colors:
      primary: '#6366f1'
  layout:
    showLeftSidebar: true
    showRightSidebar: false
input:
  keybindings:
    - key: ctrl+k
      command: command_palette.open
commands:
  - id: command_palette.open
    title: Open Command Palette
provider:
  type: mock
  mock: {}
debug:
  showPerformanceOverlay: false
''';

      final parser = YamlConfigParser();
      final parsed = parser.parse(input);
      final output = parser.stringify(parsed);

      expect(output.trimLeft().startsWith('{'), isFalse);
      expect(output, contains('configVersion: 1'));
      expect(output, contains('provider:'));

      final reparsed = parser.parse(output);
      expect(reparsed, equals(parsed));
    });
  });
}
