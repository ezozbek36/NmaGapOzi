// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConversationCWProxy {
  Conversation id(String id);

  Conversation title(String title);

  Conversation lastMessageSnippet(String? lastMessageSnippet);

  Conversation unreadCount(int unreadCount);

  Conversation updatedAt(DateTime updatedAt);

  Conversation pinned(bool pinned);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Conversation(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Conversation(...).copyWith(id: 12, name: "My name")
  /// ```
  Conversation call({
    String id,
    String title,
    String? lastMessageSnippet,
    int unreadCount,
    DateTime updatedAt,
    bool pinned,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfConversation.copyWith(...)` or call `instanceOfConversation.copyWith.fieldName(value)` for a single field.
class _$ConversationCWProxyImpl implements _$ConversationCWProxy {
  const _$ConversationCWProxyImpl(this._value);

  final Conversation _value;

  @override
  Conversation id(String id) => call(id: id);

  @override
  Conversation title(String title) => call(title: title);

  @override
  Conversation lastMessageSnippet(String? lastMessageSnippet) =>
      call(lastMessageSnippet: lastMessageSnippet);

  @override
  Conversation unreadCount(int unreadCount) => call(unreadCount: unreadCount);

  @override
  Conversation updatedAt(DateTime updatedAt) => call(updatedAt: updatedAt);

  @override
  Conversation pinned(bool pinned) => call(pinned: pinned);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Conversation(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Conversation(...).copyWith(id: 12, name: "My name")
  /// ```
  Conversation call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? lastMessageSnippet = const $CopyWithPlaceholder(),
    Object? unreadCount = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? pinned = const $CopyWithPlaceholder(),
  }) {
    return Conversation(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      title: title == const $CopyWithPlaceholder() || title == null
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      lastMessageSnippet: lastMessageSnippet == const $CopyWithPlaceholder()
          ? _value.lastMessageSnippet
          // ignore: cast_nullable_to_non_nullable
          : lastMessageSnippet as String?,
      unreadCount:
          unreadCount == const $CopyWithPlaceholder() || unreadCount == null
          ? _value.unreadCount
          // ignore: cast_nullable_to_non_nullable
          : unreadCount as int,
      updatedAt: updatedAt == const $CopyWithPlaceholder() || updatedAt == null
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
      pinned: pinned == const $CopyWithPlaceholder() || pinned == null
          ? _value.pinned
          // ignore: cast_nullable_to_non_nullable
          : pinned as bool,
    );
  }
}

extension $ConversationCopyWith on Conversation {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfConversation.copyWith(...)` or `instanceOfConversation.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConversationCWProxy get copyWith => _$ConversationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
  id: json['id'] as String,
  title: json['title'] as String,
  lastMessageSnippet: json['lastMessageSnippet'] as String?,
  unreadCount: (json['unreadCount'] as num).toInt(),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  pinned: json['pinned'] as bool,
);

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'lastMessageSnippet': instance.lastMessageSnippet,
      'unreadCount': instance.unreadCount,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'pinned': instance.pinned,
    };
