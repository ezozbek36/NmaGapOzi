// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MessageCWProxy {
  Message id(String id);

  Message conversationId(String conversationId);

  Message senderLabel(String senderLabel);

  Message text(String text);

  Message createdAt(DateTime createdAt);

  Message direction(MessageDirection direction);

  Message status(MessageStatus status);

  Message clientId(String? clientId);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Message(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Message(...).copyWith(id: 12, name: "My name")
  /// ```
  Message call({
    String id,
    String conversationId,
    String senderLabel,
    String text,
    DateTime createdAt,
    MessageDirection direction,
    MessageStatus status,
    String? clientId,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMessage.copyWith(...)` or call `instanceOfMessage.copyWith.fieldName(value)` for a single field.
class _$MessageCWProxyImpl implements _$MessageCWProxy {
  const _$MessageCWProxyImpl(this._value);

  final Message _value;

  @override
  Message id(String id) => call(id: id);

  @override
  Message conversationId(String conversationId) =>
      call(conversationId: conversationId);

  @override
  Message senderLabel(String senderLabel) => call(senderLabel: senderLabel);

  @override
  Message text(String text) => call(text: text);

  @override
  Message createdAt(DateTime createdAt) => call(createdAt: createdAt);

  @override
  Message direction(MessageDirection direction) => call(direction: direction);

  @override
  Message status(MessageStatus status) => call(status: status);

  @override
  Message clientId(String? clientId) => call(clientId: clientId);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Message(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Message(...).copyWith(id: 12, name: "My name")
  /// ```
  Message call({
    Object? id = const $CopyWithPlaceholder(),
    Object? conversationId = const $CopyWithPlaceholder(),
    Object? senderLabel = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? direction = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? clientId = const $CopyWithPlaceholder(),
  }) {
    return Message(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      conversationId:
          conversationId == const $CopyWithPlaceholder() ||
              conversationId == null
          ? _value.conversationId
          // ignore: cast_nullable_to_non_nullable
          : conversationId as String,
      senderLabel:
          senderLabel == const $CopyWithPlaceholder() || senderLabel == null
          ? _value.senderLabel
          // ignore: cast_nullable_to_non_nullable
          : senderLabel as String,
      text: text == const $CopyWithPlaceholder() || text == null
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      direction: direction == const $CopyWithPlaceholder() || direction == null
          ? _value.direction
          // ignore: cast_nullable_to_non_nullable
          : direction as MessageDirection,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as MessageStatus,
      clientId: clientId == const $CopyWithPlaceholder()
          ? _value.clientId
          // ignore: cast_nullable_to_non_nullable
          : clientId as String?,
    );
  }
}

extension $MessageCopyWith on Message {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMessage.copyWith(...)` or `instanceOfMessage.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MessageCWProxy get copyWith => _$MessageCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  senderLabel: json['senderLabel'] as String,
  text: json['text'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  direction: $enumDecode(_$MessageDirectionEnumMap, json['direction']),
  status: $enumDecode(_$MessageStatusEnumMap, json['status']),
  clientId: json['clientId'] as String?,
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'senderLabel': instance.senderLabel,
  'text': instance.text,
  'createdAt': instance.createdAt.toIso8601String(),
  'direction': _$MessageDirectionEnumMap[instance.direction]!,
  'status': _$MessageStatusEnumMap[instance.status]!,
  'clientId': instance.clientId,
};

const _$MessageDirectionEnumMap = {
  MessageDirection.incoming: 'incoming',
  MessageDirection.outgoing: 'outgoing',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.failed: 'failed',
};
