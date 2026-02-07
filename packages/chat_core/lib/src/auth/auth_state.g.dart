// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthenticatedCWProxy {
  Authenticated session(ProviderSession session);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Authenticated(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Authenticated(...).copyWith(id: 12, name: "My name")
  /// ```
  Authenticated call({ProviderSession session});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAuthenticated.copyWith(...)` or call `instanceOfAuthenticated.copyWith.fieldName(value)` for a single field.
class _$AuthenticatedCWProxyImpl implements _$AuthenticatedCWProxy {
  const _$AuthenticatedCWProxyImpl(this._value);

  final Authenticated _value;

  @override
  Authenticated session(ProviderSession session) => call(session: session);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Authenticated(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Authenticated(...).copyWith(id: 12, name: "My name")
  /// ```
  Authenticated call({Object? session = const $CopyWithPlaceholder()}) {
    return Authenticated(
      session == const $CopyWithPlaceholder() || session == null
          ? _value.session
          // ignore: cast_nullable_to_non_nullable
          : session as ProviderSession,
    );
  }
}

extension $AuthenticatedCopyWith on Authenticated {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAuthenticated.copyWith(...)` or `instanceOfAuthenticated.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthenticatedCWProxy get copyWith => _$AuthenticatedCWProxyImpl(this);
}

abstract class _$AuthErrorCWProxy {
  AuthError error(String error);

  AuthError canRetry(bool canRetry);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AuthError(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AuthError(...).copyWith(id: 12, name: "My name")
  /// ```
  AuthError call({String error, bool canRetry});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAuthError.copyWith(...)` or call `instanceOfAuthError.copyWith.fieldName(value)` for a single field.
class _$AuthErrorCWProxyImpl implements _$AuthErrorCWProxy {
  const _$AuthErrorCWProxyImpl(this._value);

  final AuthError _value;

  @override
  AuthError error(String error) => call(error: error);

  @override
  AuthError canRetry(bool canRetry) => call(canRetry: canRetry);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AuthError(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AuthError(...).copyWith(id: 12, name: "My name")
  /// ```
  AuthError call({
    Object? error = const $CopyWithPlaceholder(),
    Object? canRetry = const $CopyWithPlaceholder(),
  }) {
    return AuthError(
      error == const $CopyWithPlaceholder() || error == null
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as String,
      canRetry: canRetry == const $CopyWithPlaceholder() || canRetry == null
          ? _value.canRetry
          // ignore: cast_nullable_to_non_nullable
          : canRetry as bool,
    );
  }
}

extension $AuthErrorCopyWith on AuthError {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAuthError.copyWith(...)` or `instanceOfAuthError.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthErrorCWProxy get copyWith => _$AuthErrorCWProxyImpl(this);
}
