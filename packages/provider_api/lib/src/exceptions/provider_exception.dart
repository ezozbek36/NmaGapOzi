abstract class ProviderException implements Exception {
  final String message;
  final dynamic originalError;

  const ProviderException(this.message, [this.originalError]);

  @override
  String toString() => 'ProviderException: $message ${originalError ?? ''}';
}

class AuthenticationException extends ProviderException {
  const AuthenticationException(super.message, [super.originalError]);
}

class NetworkException extends ProviderException {
  const NetworkException(super.message, [super.originalError]);
}

class RateLimitException extends ProviderException {
  const RateLimitException(super.message, [super.originalError]);
}
