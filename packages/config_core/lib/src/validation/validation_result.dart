class ValidationError {
  final String path;
  final String message;

  ValidationError(this.path, this.message);

  @override
  String toString() => '$path: $message';
}

class ValidationWarning {
  final String path;
  final String message;

  ValidationWarning(this.path, this.message);

  @override
  String toString() => '$path: $message';
}

class ValidationResult {
  final List<ValidationError> errors;
  final List<ValidationWarning> warnings;

  ValidationResult({this.errors = const [], this.warnings = const []});

  bool get isValid => errors.isEmpty;
}
