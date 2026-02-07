import '../schema/app_config.dart';

class ConfigMerger {
  /// Merges the default config with user config and runtime overrides.
  ///
  /// [defaults] is the base configuration.
  /// [userConfig] is the partial configuration loaded from disk (YAML converted to Map).
  /// [runtimeOverrides] are temporary overrides (e.g. from command line or settings UI).
  ///
  /// Note: Lists are replaced, not merged. Maps are merged recursively.
  AppConfig merge({required AppConfig defaults, Map<String, dynamic>? userConfig, Map<String, dynamic>? runtimeOverrides}) {
    // Start with defaults
    final defaultMap = defaults.toJson();
    var merged = Map<String, dynamic>.from(defaultMap);

    // Apply user config
    if (userConfig != null) {
      merged = _deepMerge(merged, userConfig);
    }

    // Apply runtime overrides
    if (runtimeOverrides != null) {
      merged = _deepMerge(merged, runtimeOverrides);
    }

    return AppConfig.fromJson(merged);
  }

  Map<String, dynamic> _deepMerge(Map<String, dynamic> source, Map<String, dynamic> updates) {
    final out = Map<String, dynamic>.from(source);
    for (final key in updates.keys) {
      final value = updates[key];
      // Recursively merge maps
      if (value is Map && out[key] is Map) {
        final sourceChild = Map<String, dynamic>.from(out[key] as Map);
        // Handle incoming map which might be Map<dynamic, dynamic> (e.g. from YAML)
        final updateChild = Map<String, dynamic>.from(value.cast<String, dynamic>());
        out[key] = _deepMerge(sourceChild, updateChild);
      } else if (value != null) {
        // Overwrite directly for primitives and lists
        out[key] = value;
      }
    }
    return out;
  }
}
