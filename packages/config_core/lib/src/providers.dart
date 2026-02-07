import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'schema/app_config.dart';
import 'loading/config_loader.dart';
import 'defaults/default_config.dart';
import 'migration/config_migrator.dart';
import 'migration/migrations/v1_to_v2.dart';
import 'validation/config_validator.dart';

final configLoaderProvider = Provider<ConfigLoader>((ref) {
  return ConfigLoader(migrator: ConfigMigrator([MigrationV1ToV2()]), validator: ConfigValidator());
});

/// Provides a stream of configuration updates (hot reload).
final configStreamProvider = StreamProvider<AppConfig>((ref) {
  final loader = ref.watch(configLoaderProvider);
  return loader.watch();
});

/// Provides the current configuration.
/// Returns [DefaultConfig.value] while loading or on error.
final configProvider = Provider<AppConfig>((ref) {
  final asyncConfig = ref.watch(configStreamProvider);
  return asyncConfig.when(
    data: (config) => config,
    loading: () => DefaultConfig.value,
    error: (err, stack) {
      return DefaultConfig.value;
    },
  );
});
