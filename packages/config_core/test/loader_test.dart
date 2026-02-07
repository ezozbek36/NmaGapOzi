import 'package:config_core/config_core.dart';
import 'package:config_core/src/loading/config_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ConfigLoader', () {
    late ConfigLoader loader;

    setUp(() {
      loader = ConfigLoader(validator: ConfigValidator(), migrator: ConfigMigrator([]));
    });

    test('load() returns valid default config when no overrides', () async {
      final config = await loader.load();
      expect(config.configVersion, 1);
    });

    test('load() throws ConfigValidationException when runtime overrides are invalid', () async {
      // Create invalid overrides (e.g. negative width)
      final overrides = {
        'ui': {
          'layout': {'leftSidebarWidth': -100.0},
        },
      };

      expect(() => loader.load(runtimeOverrides: overrides), throwsA(isA<ConfigValidationException>()));
    });

    test('load() throws ConfigValidationException when theme mode is invalid', () async {
      final overrides = {
        'ui': {
          'theme': {'mode': 'invalid_mode'},
        },
      };

      expect(() => loader.load(runtimeOverrides: overrides), throwsA(isA<ConfigValidationException>()));
    });
  });
}
