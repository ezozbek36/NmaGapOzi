import 'migration.dart';

class ConfigMigrator {
  final List<Migration> _migrations;

  ConfigMigrator(List<Migration> migrations) : _migrations = migrations;

  Map<String, dynamic> migrate(Map<String, dynamic> rawConfig) {
    var current = Map<String, dynamic>.from(rawConfig);
    var version = current['configVersion'] as int? ?? 0;

    // Sort migrations to apply them in order
    final sortedMigrations = List<Migration>.from(_migrations)..sort((a, b) => a.fromVersion.compareTo(b.fromVersion));

    for (final migration in sortedMigrations) {
      if (migration.fromVersion == version) {
        current = migration.migrate(current);
        version = migration.toVersion;
        // Ensure version is updated in the map
        current['configVersion'] = version;
      }
    }

    return current;
  }
}
