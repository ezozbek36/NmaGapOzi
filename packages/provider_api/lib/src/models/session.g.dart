// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProviderSessionCWProxy {
  ProviderSession userId(String userId);

  ProviderSession displayName(String displayName);

  ProviderSession expiresAt(DateTime expiresAt);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ProviderSession(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProviderSession(...).copyWith(id: 12, name: "My name")
  /// ```
  ProviderSession call({String userId, String displayName, DateTime expiresAt});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfProviderSession.copyWith(...)` or call `instanceOfProviderSession.copyWith.fieldName(value)` for a single field.
class _$ProviderSessionCWProxyImpl implements _$ProviderSessionCWProxy {
  const _$ProviderSessionCWProxyImpl(this._value);

  final ProviderSession _value;

  @override
  ProviderSession userId(String userId) => call(userId: userId);

  @override
  ProviderSession displayName(String displayName) =>
      call(displayName: displayName);

  @override
  ProviderSession expiresAt(DateTime expiresAt) => call(expiresAt: expiresAt);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ProviderSession(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProviderSession(...).copyWith(id: 12, name: "My name")
  /// ```
  ProviderSession call({
    Object? userId = const $CopyWithPlaceholder(),
    Object? displayName = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return ProviderSession(
      userId: userId == const $CopyWithPlaceholder() || userId == null
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as String,
      displayName:
          displayName == const $CopyWithPlaceholder() || displayName == null
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String,
      expiresAt: expiresAt == const $CopyWithPlaceholder() || expiresAt == null
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
    );
  }
}

extension $ProviderSessionCopyWith on ProviderSession {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfProviderSession.copyWith(...)` or `instanceOfProviderSession.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProviderSessionCWProxy get copyWith => _$ProviderSessionCWProxyImpl(this);
}

abstract class _$LoginParamsCWProxy {
  LoginParams username(String username);

  LoginParams code(String code);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LoginParams(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LoginParams(...).copyWith(id: 12, name: "My name")
  /// ```
  LoginParams call({String username, String code});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLoginParams.copyWith(...)` or call `instanceOfLoginParams.copyWith.fieldName(value)` for a single field.
class _$LoginParamsCWProxyImpl implements _$LoginParamsCWProxy {
  const _$LoginParamsCWProxyImpl(this._value);

  final LoginParams _value;

  @override
  LoginParams username(String username) => call(username: username);

  @override
  LoginParams code(String code) => call(code: code);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LoginParams(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LoginParams(...).copyWith(id: 12, name: "My name")
  /// ```
  LoginParams call({
    Object? username = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
  }) {
    return LoginParams(
      username: username == const $CopyWithPlaceholder() || username == null
          ? _value.username
          // ignore: cast_nullable_to_non_nullable
          : username as String,
      code: code == const $CopyWithPlaceholder() || code == null
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
    );
  }
}

extension $LoginParamsCopyWith on LoginParams {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLoginParams.copyWith(...)` or `instanceOfLoginParams.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LoginParamsCWProxy get copyWith => _$LoginParamsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderSession _$ProviderSessionFromJson(Map<String, dynamic> json) =>
    ProviderSession(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$ProviderSessionToJson(ProviderSession instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

LoginParams _$LoginParamsFromJson(Map<String, dynamic> json) => LoginParams(
  username: json['username'] as String,
  code: json['code'] as String,
);

Map<String, dynamic> _$LoginParamsToJson(LoginParams instance) =>
    <String, dynamic>{'username': instance.username, 'code': instance.code};
