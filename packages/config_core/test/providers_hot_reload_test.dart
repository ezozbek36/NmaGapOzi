import 'dart:async';
import 'dart:io';

import 'package:config_core/config_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Config providers', () {
    late Directory tempDir;
    late String configPath;
    late ConfigLoader loader;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('config_core_providers_test_');
      configPath = '${tempDir.path}/config.yaml';

      await File(configPath).writeAsString(_configWithThemeMode('light'), flush: true);

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

    test('configProvider updates after config file changes', () async {
      final container = ProviderContainer(overrides: [configLoaderProvider.overrideWithValue(loader)]);
      addTearDown(container.dispose);

      final updatedConfig = Completer<AppConfig>();
      final subscription = container.listen<AppConfig>(configProvider, (_, next) {
        if (next.ui.theme.mode == 'dark' && !updatedConfig.isCompleted) {
          updatedConfig.complete(next);
        }
      }, fireImmediately: true);
      addTearDown(subscription.close);

      final initialConfig = await container.read(configStreamProvider.future);
      expect(initialConfig.ui.theme.mode, 'light');

      await File(configPath).writeAsString(_configWithThemeMode('dark'), flush: true);

      final reloadedConfig = await updatedConfig.future.timeout(const Duration(seconds: 10));
      expect(reloadedConfig.ui.theme.mode, 'dark');
      expect(container.read(configProvider).ui.theme.mode, 'dark');
    });
  });
}

String _configWithThemeMode(String mode) {
  return 'ui:\n  theme:\n    mode: $mode\n';
}
