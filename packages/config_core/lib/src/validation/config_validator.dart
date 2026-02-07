import '../schema/app_config.dart';
import 'validation_result.dart';

class ConfigValidator {
  ValidationResult validate(AppConfig config) {
    final errors = <ValidationError>[];
    final warnings = <ValidationWarning>[];

    // Validate Theme
    if (!['light', 'dark', 'system'].contains(config.ui.theme.mode)) {
      errors.add(ValidationError('ui.theme.mode', 'Must be one of: light, dark, system'));
    }

    // Validate Layout
    if (config.ui.layout.leftSidebarWidth < 0) {
      errors.add(ValidationError('ui.layout.leftSidebarWidth', 'Must be non-negative'));
    }
    if (config.ui.layout.rightSidebarWidth < 0) {
      errors.add(ValidationError('ui.layout.rightSidebarWidth', 'Must be non-negative'));
    }

    // Validate Mock Provider Settings
    if (config.provider.mock != null) {
      final mock = config.provider.mock!;
      if (mock.latencyMinMs > mock.latencyMaxMs) {
        errors.add(ValidationError('provider.mock', 'latencyMinMs cannot be greater than latencyMaxMs'));
      }
      if (mock.failRate < 0 || mock.failRate > 1) {
        errors.add(ValidationError('provider.mock.failRate', 'Must be between 0.0 and 1.0'));
      }
    }

    return ValidationResult(errors: errors, warnings: warnings);
  }
}
