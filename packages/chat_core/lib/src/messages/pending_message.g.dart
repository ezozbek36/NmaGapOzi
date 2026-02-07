// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_message.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PendingMessageCWProxy {
  PendingMessage clientId(String clientId);

  PendingMessage text(String text);

  PendingMessage status(MessageStatus status);

  PendingMessage retryCount(int retryCount);

  PendingMessage error(String? error);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PendingMessage(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PendingMessage(...).copyWith(id: 12, name: "My name")
  /// ```
  PendingMessage call({
    String clientId,
    String text,
    MessageStatus status,
    int retryCount,
    String? error,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfPendingMessage.copyWith(...)` or call `instanceOfPendingMessage.copyWith.fieldName(value)` for a single field.
class _$PendingMessageCWProxyImpl implements _$PendingMessageCWProxy {
  const _$PendingMessageCWProxyImpl(this._value);

  final PendingMessage _value;

  @override
  PendingMessage clientId(String clientId) => call(clientId: clientId);

  @override
  PendingMessage text(String text) => call(text: text);

  @override
  PendingMessage status(MessageStatus status) => call(status: status);

  @override
  PendingMessage retryCount(int retryCount) => call(retryCount: retryCount);

  @override
  PendingMessage error(String? error) => call(error: error);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PendingMessage(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PendingMessage(...).copyWith(id: 12, name: "My name")
  /// ```
  PendingMessage call({
    Object? clientId = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? retryCount = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
  }) {
    return PendingMessage(
      clientId: clientId == const $CopyWithPlaceholder() || clientId == null
          ? _value.clientId
          // ignore: cast_nullable_to_non_nullable
          : clientId as String,
      text: text == const $CopyWithPlaceholder() || text == null
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as MessageStatus,
      retryCount:
          retryCount == const $CopyWithPlaceholder() || retryCount == null
          ? _value.retryCount
          // ignore: cast_nullable_to_non_nullable
          : retryCount as int,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as String?,
    );
  }
}

extension $PendingMessageCopyWith on PendingMessage {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfPendingMessage.copyWith(...)` or `instanceOfPendingMessage.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PendingMessageCWProxy get copyWith => _$PendingMessageCWProxyImpl(this);
}
