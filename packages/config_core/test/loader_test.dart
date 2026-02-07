import 'dart:io';

import 'package:config_core/config_core.dart';
import 'package:config_core/src/loading/config_exception.dart';
import 'package:test/test.dart';

void main() {
  group('ConfigLoader', () {
    late ConfigLoader loader;
    late Directory tempDir;
    late String configPath;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('config_core_loader_test_');
      configPath = '${tempDir.path}/config.yaml';
      loader = ConfigLoader(
        validator: ConfigValidator(),
        migrator: ConfigMigrator([]),
        configPathProvider: () async => configPath,
        configDirProvider: () async => tempDir.path,
      );
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
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

    test('load() throws ConfigParseException when parser fails', () async {
      await File(configPath).writeAsString('not-empty');

      final parserLoader = ConfigLoader(
        validator: ConfigValidator(),
        migrator: ConfigMigrator([]),
        parser: _ThrowingParser(),
        configPathProvider: () async => configPath,
        configDirProvider: () async => tempDir.path,
      );

      expect(() => parserLoader.load(), throwsA(isA<ConfigParseException>()));
    });

    test('load() throws ConfigMigrationException when migration fails', () async {
      await File(configPath).writeAsString('{"configVersion":1}');

      final migrationLoader = ConfigLoader(
        validator: ConfigValidator(),
        migrator: _ThrowingMigrator(),
        parser: _StaticParser({'configVersion': 1}),
        configPathProvider: () async => configPath,
        configDirProvider: () async => tempDir.path,
      );

      expect(() => migrationLoader.load(), throwsA(isA<ConfigMigrationException>()));
    });

    test('save() writes YAML output', () async {
      final config = await loader.load();

      await loader.save(config);

      final saved = await File(configPath).readAsString();
      expect(saved.trimLeft().startsWith('{'), isFalse);
      expect(saved, contains('configVersion: 1'));
      expect(saved, contains('ui:'));

      final reparsed = YamlConfigParser().parse(saved);
      expect(reparsed['configVersion'], 1);
    });
  });
}

class _ThrowingParser implements ConfigParser {
  @override
  Map<String, dynamic> parse(String content) => throw const FormatException('invalid');

  @override
  String stringify(Map<String, dynamic> config) => '{}';

  @override
  bool supportsPath(String path) => true;
}

class _StaticParser implements ConfigParser {
  final Map<String, dynamic> _value;

  _StaticParser(this._value);

  @override
  Map<String, dynamic> parse(String content) => Map<String, dynamic>.from(_value);

  @override
  String stringify(Map<String, dynamic> config) => '{}';

  @override
  bool supportsPath(String path) => true;
}

class _ThrowingMigrator extends ConfigMigrator {
  _ThrowingMigrator() : super(const []);

  @override
  Map<String, dynamic> migrate(Map<String, dynamic> rawConfig) {
    throw StateError('migration failed');
  }
}
