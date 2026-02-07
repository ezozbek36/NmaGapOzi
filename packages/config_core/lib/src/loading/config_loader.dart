import 'dart:io';
import 'package:watcher/watcher.dart';

import '../schema/app_config.dart';
import '../defaults/default_config.dart';
import '../merging/config_merger.dart';
import '../migration/config_migrator.dart';
import '../validation/config_validator.dart';
import 'config_parser.dart';
import 'config_exception.dart';
import 'config_paths.dart';
import 'yaml_config_parser.dart';

class ConfigLoader {
  final ConfigMerger _merger;
  final ConfigMigrator _migrator;
  final ConfigValidator _validator;
  final ConfigParser _parser;

  ConfigLoader({ConfigMerger? merger, ConfigMigrator? migrator, ConfigValidator? validator, ConfigParser? parser})
    : _merger = merger ?? ConfigMerger(),
      _migrator = migrator ?? ConfigMigrator([]),
      _validator = validator ?? ConfigValidator(),
      _parser = parser ?? YamlConfigParser();

  /// Loads the configuration.
  ///
  /// 1. Loads defaults.
  /// 2. Loads user config from file (if exists).
  /// 3. Migrates user config (if needed).
  /// 4. Merges defaults + user + runtimeOverrides.
  /// 5. Validates the merged config.
  Future<AppConfig> load({Map<String, dynamic>? runtimeOverrides}) async {
    final defaults = DefaultConfig.value;
    Map<String, dynamic>? userConfig;

    try {
      final path = await ConfigPaths.getConfigPath();
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          userConfig = _parser.parse(content);
        }
      }
    } catch (_) {
      // Ignore errors (missing file, permission issues, invalid YAML)
    }

    // Apply migrations to user config
    if (userConfig != null) {
      try {
        userConfig = _migrator.migrate(userConfig);
      } catch (_) {
        // Ignore migration errors
      }
    }

    final config = _merger.merge(defaults: defaults, userConfig: userConfig, runtimeOverrides: runtimeOverrides);

    // Validate
    final validation = _validator.validate(config);
    if (!validation.isValid) {
      throw ConfigValidationException(validation.errors.map((e) => e.toString()).toList());
    }

    return config;
  }

  /// Saves the current config to the user config file.
  Future<void> save(AppConfig config) async {
    final path = await ConfigPaths.getConfigPath();
    final file = File(path);

    // Ensure directory exists
    await file.parent.create(recursive: true);

    final map = config.toJson();
    final encoded = _parser.stringify(map);
    await file.writeAsString(encoded);
  }

  /// Watches for changes in the configuration file.
  Stream<AppConfig> watch() async* {
    // Yield initial value
    yield await load();

    final dirPath = await ConfigPaths.getConfigDir();
    final dir = Directory(dirPath);

    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
      } catch (_) {
        return;
      }
    }

    final watcher = DirectoryWatcher(dirPath);
    await for (final event in watcher.events) {
      if (_parser.supportsPath(event.path)) {
        yield await load();
      }
    }
  }
}
