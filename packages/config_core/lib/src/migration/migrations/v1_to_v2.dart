import '../migration.dart';

class MigrationV1ToV2 extends Migration {
  @override
  int get fromVersion => 1;

  @override
  int get toVersion => 2;

  @override
  Map<String, dynamic> migrate(Map<String, dynamic> config) {
    final newConfig = Map<String, dynamic>.from(config);

    // V1 to V2 migration logic would go here.
    // Currently no structural changes require migration.

    return newConfig;
  }
}
