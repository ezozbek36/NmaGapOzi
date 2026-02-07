class ConfigException implements Exception {
  final String message;
  ConfigException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class ConfigReadException extends ConfigException {
  ConfigReadException({required String path, required Object cause}) : super('Failed to read config file "$path": $cause');
}

class ConfigParseException extends ConfigException {
  ConfigParseException({required String path, required Object cause}) : super('Failed to parse config file "$path": $cause');
}

class ConfigMigrationException extends ConfigException {
  ConfigMigrationException({required String path, required Object cause}) : super('Failed to migrate config file "$path": $cause');
}

class ConfigWatchException extends ConfigException {
  ConfigWatchException({required String path, required Object cause}) : super('Failed to watch config directory "$path": $cause');
}

class ConfigValidationException extends ConfigException {
  final List<String> errors;

  ConfigValidationException(this.errors) : super('Configuration validation failed');

  @override
  String toString() => 'ConfigValidationException: ${errors.join(", ")}';
}
