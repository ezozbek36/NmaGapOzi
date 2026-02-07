import 'package:config_core/config_core.dart';
import 'package:test/test.dart';

void main() {
  group('ConfigMerger', () {
    final merger = ConfigMerger();
    final defaults = DefaultConfig.value;

    test('defaults are preserved when user config is null', () {
      final merged = merger.merge(defaults: defaults, userConfig: null);
      expect(merged, defaults);
    });

    test('user config overrides specific fields', () {
      final userConfig = {
        'ui': {
          'theme': {'mode': 'dark'},
        },
      };
      final merged = merger.merge(defaults: defaults, userConfig: userConfig);

      expect(merged.ui.theme.mode, 'dark');
      // Verify other fields remain default
      expect(merged.ui.layout.showLeftSidebar, defaults.ui.layout.showLeftSidebar);
    });

    test('deep merge works for nested maps', () {
      // defaults colors has many keys.
      // user overrides one color.
      final userConfig = {
        'ui': {
          'theme': {
            'colors': {'primary': '#000000'},
          },
        },
      };
      final merged = merger.merge(defaults: defaults, userConfig: userConfig);
      expect(merged.ui.theme.colors['primary'], '#000000');
      // Other colors should exist
      expect(merged.ui.theme.colors['background'], defaults.ui.theme.colors['background']);
    });

    test('runtime overrides take precedence over user config', () {
      final userConfig = {
        'ui': {
          'theme': {'mode': 'dark'},
        },
      };
      final overrides = {
        'ui': {
          'theme': {'mode': 'light'},
        },
      };

      final merged = merger.merge(defaults: defaults, userConfig: userConfig, runtimeOverrides: overrides);

      expect(merged.ui.theme.mode, 'light');
    });
  });
}
