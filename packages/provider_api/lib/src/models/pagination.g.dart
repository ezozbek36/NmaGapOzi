// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConversationPageCWProxy {
  ConversationPage items(List<Conversation> items);

  ConversationPage nextCursor(String? nextCursor);

  ConversationPage hasMore(bool hasMore);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ConversationPage(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ConversationPage(...).copyWith(id: 12, name: "My name")
  /// ```
  ConversationPage call({
    List<Conversation> items,
    String? nextCursor,
    bool hasMore,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfConversationPage.copyWith(...)` or call `instanceOfConversationPage.copyWith.fieldName(value)` for a single field.
class _$ConversationPageCWProxyImpl implements _$ConversationPageCWProxy {
  const _$ConversationPageCWProxyImpl(this._value);

  final ConversationPage _value;

  @override
  ConversationPage items(List<Conversation> items) => call(items: items);

  @override
  ConversationPage nextCursor(String? nextCursor) =>
      call(nextCursor: nextCursor);

  @override
  ConversationPage hasMore(bool hasMore) => call(hasMore: hasMore);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ConversationPage(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ConversationPage(...).copyWith(id: 12, name: "My name")
  /// ```
  ConversationPage call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
    Object? hasMore = const $CopyWithPlaceholder(),
  }) {
    return ConversationPage(
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<Conversation>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
      hasMore: hasMore == const $CopyWithPlaceholder() || hasMore == null
          ? _value.hasMore
          // ignore: cast_nullable_to_non_nullable
          : hasMore as bool,
    );
  }
}

extension $ConversationPageCopyWith on ConversationPage {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfConversationPage.copyWith(...)` or `instanceOfConversationPage.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConversationPageCWProxy get copyWith => _$ConversationPageCWProxyImpl(this);
}

abstract class _$MessagePageCWProxy {
  MessagePage items(List<Message> items);

  MessagePage hasMore(bool hasMore);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MessagePage(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MessagePage(...).copyWith(id: 12, name: "My name")
  /// ```
  MessagePage call({List<Message> items, bool hasMore});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMessagePage.copyWith(...)` or call `instanceOfMessagePage.copyWith.fieldName(value)` for a single field.
class _$MessagePageCWProxyImpl implements _$MessagePageCWProxy {
  const _$MessagePageCWProxyImpl(this._value);

  final MessagePage _value;

  @override
  MessagePage items(List<Message> items) => call(items: items);

  @override
  MessagePage hasMore(bool hasMore) => call(hasMore: hasMore);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MessagePage(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MessagePage(...).copyWith(id: 12, name: "My name")
  /// ```
  MessagePage call({
    Object? items = const $CopyWithPlaceholder(),
    Object? hasMore = const $CopyWithPlaceholder(),
  }) {
    return MessagePage(
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<Message>,
      hasMore: hasMore == const $CopyWithPlaceholder() || hasMore == null
          ? _value.hasMore
          // ignore: cast_nullable_to_non_nullable
          : hasMore as bool,
    );
  }
}

extension $MessagePageCopyWith on MessagePage {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMessagePage.copyWith(...)` or `instanceOfMessagePage.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MessagePageCWProxy get copyWith => _$MessagePageCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationPage _$ConversationPageFromJson(Map<String, dynamic> json) =>
    ConversationPage(
      items: (json['items'] as List<dynamic>)
          .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$ConversationPageToJson(ConversationPage instance) =>
    <String, dynamic>{
      'items': instance.items,
      'nextCursor': instance.nextCursor,
      'hasMore': instance.hasMore,
    };

MessagePage _$MessagePageFromJson(Map<String, dynamic> json) => MessagePage(
  items: (json['items'] as List<dynamic>)
      .map((e) => Message.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasMore: json['hasMore'] as bool,
);

Map<String, dynamic> _$MessagePageToJson(MessagePage instance) =>
    <String, dynamic>{'items': instance.items, 'hasMore': instance.hasMore};
