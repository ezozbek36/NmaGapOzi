// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_list_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConversationListStateCWProxy {
  ConversationListState items(List<Conversation> items);

  ConversationListState isLoading(bool isLoading);

  ConversationListState hasMore(bool hasMore);

  ConversationListState error(String? error);

  ConversationListState searchQuery(String? searchQuery);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ConversationListState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ConversationListState(...).copyWith(id: 12, name: "My name")
  /// ```
  ConversationListState call({
    List<Conversation> items,
    bool isLoading,
    bool hasMore,
    String? error,
    String? searchQuery,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfConversationListState.copyWith(...)` or call `instanceOfConversationListState.copyWith.fieldName(value)` for a single field.
class _$ConversationListStateCWProxyImpl
    implements _$ConversationListStateCWProxy {
  const _$ConversationListStateCWProxyImpl(this._value);

  final ConversationListState _value;

  @override
  ConversationListState items(List<Conversation> items) => call(items: items);

  @override
  ConversationListState isLoading(bool isLoading) => call(isLoading: isLoading);

  @override
  ConversationListState hasMore(bool hasMore) => call(hasMore: hasMore);

  @override
  ConversationListState error(String? error) => call(error: error);

  @override
  ConversationListState searchQuery(String? searchQuery) =>
      call(searchQuery: searchQuery);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ConversationListState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ConversationListState(...).copyWith(id: 12, name: "My name")
  /// ```
  ConversationListState call({
    Object? items = const $CopyWithPlaceholder(),
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? hasMore = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
    Object? searchQuery = const $CopyWithPlaceholder(),
  }) {
    return ConversationListState(
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<Conversation>,
      isLoading: isLoading == const $CopyWithPlaceholder() || isLoading == null
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
      hasMore: hasMore == const $CopyWithPlaceholder() || hasMore == null
          ? _value.hasMore
          // ignore: cast_nullable_to_non_nullable
          : hasMore as bool,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as String?,
      searchQuery: searchQuery == const $CopyWithPlaceholder()
          ? _value.searchQuery
          // ignore: cast_nullable_to_non_nullable
          : searchQuery as String?,
    );
  }
}

extension $ConversationListStateCopyWith on ConversationListState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfConversationListState.copyWith(...)` or `instanceOfConversationListState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConversationListStateCWProxy get copyWith =>
      _$ConversationListStateCWProxyImpl(this);
}
