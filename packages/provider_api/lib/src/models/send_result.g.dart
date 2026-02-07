// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_result.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SendResultCWProxy {
  SendResult clientMessageId(String clientMessageId);

  SendResult accepted(bool accepted);

  SendResult error(String? error);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SendResult(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SendResult(...).copyWith(id: 12, name: "My name")
  /// ```
  SendResult call({String clientMessageId, bool accepted, String? error});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSendResult.copyWith(...)` or call `instanceOfSendResult.copyWith.fieldName(value)` for a single field.
class _$SendResultCWProxyImpl implements _$SendResultCWProxy {
  const _$SendResultCWProxyImpl(this._value);

  final SendResult _value;

  @override
  SendResult clientMessageId(String clientMessageId) =>
      call(clientMessageId: clientMessageId);

  @override
  SendResult accepted(bool accepted) => call(accepted: accepted);

  @override
  SendResult error(String? error) => call(error: error);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SendResult(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SendResult(...).copyWith(id: 12, name: "My name")
  /// ```
  SendResult call({
    Object? clientMessageId = const $CopyWithPlaceholder(),
    Object? accepted = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
  }) {
    return SendResult(
      clientMessageId:
          clientMessageId == const $CopyWithPlaceholder() ||
              clientMessageId == null
          ? _value.clientMessageId
          // ignore: cast_nullable_to_non_nullable
          : clientMessageId as String,
      accepted: accepted == const $CopyWithPlaceholder() || accepted == null
          ? _value.accepted
          // ignore: cast_nullable_to_non_nullable
          : accepted as bool,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as String?,
    );
  }
}

extension $SendResultCopyWith on SendResult {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSendResult.copyWith(...)` or `instanceOfSendResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SendResultCWProxy get copyWith => _$SendResultCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendResult _$SendResultFromJson(Map<String, dynamic> json) => SendResult(
  clientMessageId: json['clientMessageId'] as String,
  accepted: json['accepted'] as bool,
  error: json['error'] as String?,
);

Map<String, dynamic> _$SendResultToJson(SendResult instance) =>
    <String, dynamic>{
      'clientMessageId': instance.clientMessageId,
      'accepted': instance.accepted,
      'error': instance.error,
    };
