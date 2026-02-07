import 'package:config_core/config_core.dart';
import 'package:config_core/src/migration/migrations/v1_to_v2.dart';
import 'package:test/test.dart';

void main() {
  group('ConfigMigrator', () {
    test('migrates v1 to v2', () {
      final v1Config = {'configVersion': 1, 'dummy': 'old'};
      final migrator = ConfigMigrator([MigrationV1ToV2()]);

      final result = migrator.migrate(v1Config);
      expect(result['configVersion'], 2);
    });

    test('does nothing if already on target version', () {
      final v2Config = {'configVersion': 2, 'dummy': 'new'};
      final migrator = ConfigMigrator([MigrationV1ToV2()]);

      final result = migrator.migrate(v2Config);
      expect(result['configVersion'], 2);
    });

    test('runs multiple migrations sequentially', () {
      // Mock migrations
      final m1 = _MockMigration(1, 2);
      final m2 = _MockMigration(2, 3);
      final migrator = ConfigMigrator([m1, m2]);

      final v1 = {'configVersion': 1};
      final result = migrator.migrate(v1);

      expect(result['configVersion'], 3);
      expect(result['visited_1_2'], true);
      expect(result['visited_2_3'], true);
    });
  });
}

class _MockMigration extends Migration {
  final int _from;
  final int _to;

  _MockMigration(this._from, this._to);

  @override
  int get fromVersion => _from;

  @override
  int get toVersion => _to;

  @override
  Map<String, dynamic> migrate(Map<String, dynamic> config) {
    final newConfig = Map<String, dynamic>.from(config);
    newConfig['visited_${_from}_$_to'] = true;
    return newConfig;
  }
}
