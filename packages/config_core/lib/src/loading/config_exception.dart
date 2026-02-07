class ConfigException implements Exception {
  final String message;
  ConfigException(this.message);

  @override
  String toString() => 'ConfigException: $message';
}

class ConfigValidationException extends ConfigException {
  final List<String> errors;

  ConfigValidationException(this.errors) : super('Configuration validation failed');

  @override
  String toString() => 'ConfigValidationException: ${errors.join(", ")}';
}
