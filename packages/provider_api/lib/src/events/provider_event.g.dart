// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_event.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NewMessageEventCWProxy {
  NewMessageEvent conversationId(String conversationId);

  NewMessageEvent message(Message message);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `NewMessageEvent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// NewMessageEvent(...).copyWith(id: 12, name: "My name")
  /// ```
  NewMessageEvent call({String conversationId, Message message});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfNewMessageEvent.copyWith(...)` or call `instanceOfNewMessageEvent.copyWith.fieldName(value)` for a single field.
class _$NewMessageEventCWProxyImpl implements _$NewMessageEventCWProxy {
  const _$NewMessageEventCWProxyImpl(this._value);

  final NewMessageEvent _value;

  @override
  NewMessageEvent conversationId(String conversationId) =>
      call(conversationId: conversationId);

  @override
  NewMessageEvent message(Message message) => call(message: message);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `NewMessageEvent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// NewMessageEvent(...).copyWith(id: 12, name: "My name")
  /// ```
  NewMessageEvent call({
    Object? conversationId = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return NewMessageEvent(
      conversationId:
          conversationId == const $CopyWithPlaceholder() ||
              conversationId == null
          ? _value.conversationId
          // ignore: cast_nullable_to_non_nullable
          : conversationId as String,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as Message,
    );
  }
}

extension $NewMessageEventCopyWith on NewMessageEvent {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfNewMessageEvent.copyWith(...)` or `instanceOfNewMessageEvent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NewMessageEventCWProxy get copyWith => _$NewMessageEventCWProxyImpl(this);
}

abstract class _$MessageAckEventCWProxy {
  MessageAckEvent clientMessageId(String clientMessageId);

  MessageAckEvent serverMessageId(String serverMessageId);

  MessageAckEvent timestamp(DateTime timestamp);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MessageAckEvent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MessageAckEvent(...).copyWith(id: 12, name: "My name")
  /// ```
  MessageAckEvent call({
    String clientMessageId,
    String serverMessageId,
    DateTime timestamp,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMessageAckEvent.copyWith(...)` or call `instanceOfMessageAckEvent.copyWith.fieldName(value)` for a single field.
class _$MessageAckEventCWProxyImpl implements _$MessageAckEventCWProxy {
  const _$MessageAckEventCWProxyImpl(this._value);

  final MessageAckEvent _value;

  @override
  MessageAckEvent clientMessageId(String clientMessageId) =>
      call(clientMessageId: clientMessageId);

  @override
  MessageAckEvent serverMessageId(String serverMessageId) =>
      call(serverMessageId: serverMessageId);

  @override
  MessageAckEvent timestamp(DateTime timestamp) => call(timestamp: timestamp);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MessageAckEvent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MessageAckEvent(...).copyWith(id: 12, name: "My name")
  /// ```
  MessageAckEvent call({
    Object? clientMessageId = const $CopyWithPlaceholder(),
    Object? serverMessageId = const $CopyWithPlaceholder(),
    Object? timestamp = const $CopyWithPlaceholder(),
  }) {
    return MessageAckEvent(
      clientMessageId:
          clientMessageId == const $CopyWithPlaceholder() ||
              clientMessageId == null
          ? _value.clientMessageId
          // ignore: cast_nullable_to_non_nullable
          : clientMessageId as String,
      serverMessageId:
          serverMessageId == const $CopyWithPlaceholder() ||
              serverMessageId == null
          ? _value.serverMessageId
          // ignore: cast_nullable_to_non_nullable
          : serverMessageId as String,
      timestamp: timestamp == const $CopyWithPlaceholder() || timestamp == null
          ? _value.timestamp
          // ignore: cast_nullable_to_non_nullable
          : timestamp as DateTime,
    );
  }
}

extension $MessageAckEventCopyWith on MessageAckEvent {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMessageAckEvent.copyWith(...)` or `instanceOfMessageAckEvent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MessageAckEventCWProxy get copyWith => _$MessageAckEventCWProxyImpl(this);
}

abstract class _$MessageFailedEventCWProxy {
  MessageFailedEvent clientMessageId(String clientMessageId);

  MessageFailedEvent errorCode(String errorCode);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MessageFailedEvent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MessageFailedEvent(...).copyWith(id: 12, name: "My name")
  /// ```
  MessageFailedEvent call({String clientMessageId, String errorCode});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMessageFailedEvent.copyWith(...)` or call `instanceOfMessageFailedEvent.copyWith.fieldName(value)` for a single field.
class _$MessageFailedEventCWProxyImpl implements _$MessageFailedEventCWProxy {
  const _$MessageFailedEventCWProxyImpl(this._value);

  final MessageFailedEvent _value;

  @override
  MessageFailedEvent clientMessageId(String clientMessageId) =>
      call(clientMessageId: clientMessageId);

  @override
  MessageFailedEvent errorCode(String errorCode) => call(errorCode: errorCode);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MessageFailedEvent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MessageFailedEvent(...).copyWith(id: 12, name: "My name")
  /// ```
  MessageFailedEvent call({
    Object? clientMessageId = const $CopyWithPlaceholder(),
    Object? errorCode = const $CopyWithPlaceholder(),
  }) {
    return MessageFailedEvent(
      clientMessageId:
          clientMessageId == const $CopyWithPlaceholder() ||
              clientMessageId == null
          ? _value.clientMessageId
          // ignore: cast_nullable_to_non_nullable
          : clientMessageId as String,
      errorCode: errorCode == const $CopyWithPlaceholder() || errorCode == null
          ? _value.errorCode
          // ignore: cast_nullable_to_non_nullable
          : errorCode as String,
    );
  }
}

extension $MessageFailedEventCopyWith on MessageFailedEvent {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMessageFailedEvent.copyWith(...)` or `instanceOfMessageFailedEvent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MessageFailedEventCWProxy get copyWith =>
      _$MessageFailedEventCWProxyImpl(this);
}

abstract class _$ConversationUpdatedEventCWProxy {
  ConversationUpdatedEvent conversation(Conversation conversation);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ConversationUpdatedEvent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ConversationUpdatedEvent(...).copyWith(id: 12, name: "My name")
  /// ```
  ConversationUpdatedEvent call({Conversation conversation});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfConversationUpdatedEvent.copyWith(...)` or call `instanceOfConversationUpdatedEvent.copyWith.fieldName(value)` for a single field.
class _$ConversationUpdatedEventCWProxyImpl
    implements _$ConversationUpdatedEventCWProxy {
  const _$ConversationUpdatedEventCWProxyImpl(this._value);

  final ConversationUpdatedEvent _value;

  @override
  ConversationUpdatedEvent conversation(Conversation conversation) =>
      call(conversation: conversation);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ConversationUpdatedEvent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ConversationUpdatedEvent(...).copyWith(id: 12, name: "My name")
  /// ```
  ConversationUpdatedEvent call({
    Object? conversation = const $CopyWithPlaceholder(),
  }) {
    return ConversationUpdatedEvent(
      conversation:
          conversation == const $CopyWithPlaceholder() || conversation == null
          ? _value.conversation
          // ignore: cast_nullable_to_non_nullable
          : conversation as Conversation,
    );
  }
}

extension $ConversationUpdatedEventCopyWith on ConversationUpdatedEvent {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfConversationUpdatedEvent.copyWith(...)` or `instanceOfConversationUpdatedEvent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConversationUpdatedEventCWProxy get copyWith =>
      _$ConversationUpdatedEventCWProxyImpl(this);
}
