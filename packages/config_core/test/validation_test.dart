import 'package:config_core/config_core.dart';
import 'package:test/test.dart';

void main() {
  group('ConfigValidator', () {
    final validator = ConfigValidator();

    test('valid config passes', () {
      final config = DefaultConfig.value;
      final result = validator.validate(config);
      expect(result.isValid, true);
    });

    test('invalid theme mode fails', () {
      final config = DefaultConfig.value.copyWith(
        ui: DefaultConfig.value.ui.copyWith(theme: DefaultConfig.value.ui.theme.copyWith(mode: 'invalid')),
      );

      final result = validator.validate(config);
      expect(result.isValid, false);
      expect(result.errors.any((e) => e.path == 'ui.theme.mode'), true);
    });

    test('negative layout width fails', () {
      final config = DefaultConfig.value.copyWith(
        ui: DefaultConfig.value.ui.copyWith(layout: DefaultConfig.value.ui.layout.copyWith(leftSidebarWidth: -10)),
      );
      final result = validator.validate(config);
      expect(result.isValid, false);
      expect(result.errors.any((e) => e.path == 'ui.layout.leftSidebarWidth'), true);
    });

    test('invalid mock provider settings fail', () {
      final base = DefaultConfig.value;
      final config = base.copyWith(
        provider: base.provider.copyWith(
          mock: (base.provider.mock ?? const MockProviderSettings()).copyWith(latencyMinMs: 500, latencyMaxMs: 100, failRate: 1.5),
        ),
      );

      final result = validator.validate(config);
      expect(result.isValid, false);
      expect(result.errors.any((e) => e.path == 'provider.mock'), true);
      expect(result.errors.any((e) => e.path == 'provider.mock.failRate'), true);
    });
  });
}
