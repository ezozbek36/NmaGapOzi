// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_list_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MessageListStateCWProxy {
  MessageListState conversationId(String conversationId);

  MessageListState items(IList<Message> items);

  MessageListState pending(IList<PendingMessage> pending);

  MessageListState isLoading(bool isLoading);

  MessageListState isLoadingMore(bool isLoadingMore);

  MessageListState hasMore(bool hasMore);

  MessageListState error(String? error);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MessageListState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MessageListState(...).copyWith(id: 12, name: "My name")
  /// ```
  MessageListState call({
    String conversationId,
    IList<Message> items,
    IList<PendingMessage> pending,
    bool isLoading,
    bool isLoadingMore,
    bool hasMore,
    String? error,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMessageListState.copyWith(...)` or call `instanceOfMessageListState.copyWith.fieldName(value)` for a single field.
class _$MessageListStateCWProxyImpl implements _$MessageListStateCWProxy {
  const _$MessageListStateCWProxyImpl(this._value);

  final MessageListState _value;

  @override
  MessageListState conversationId(String conversationId) =>
      call(conversationId: conversationId);

  @override
  MessageListState items(IList<Message> items) => call(items: items);

  @override
  MessageListState pending(IList<PendingMessage> pending) =>
      call(pending: pending);

  @override
  MessageListState isLoading(bool isLoading) => call(isLoading: isLoading);

  @override
  MessageListState isLoadingMore(bool isLoadingMore) =>
      call(isLoadingMore: isLoadingMore);

  @override
  MessageListState hasMore(bool hasMore) => call(hasMore: hasMore);

  @override
  MessageListState error(String? error) => call(error: error);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MessageListState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MessageListState(...).copyWith(id: 12, name: "My name")
  /// ```
  MessageListState call({
    Object? conversationId = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? pending = const $CopyWithPlaceholder(),
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? isLoadingMore = const $CopyWithPlaceholder(),
    Object? hasMore = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
  }) {
    return MessageListState(
      conversationId:
          conversationId == const $CopyWithPlaceholder() ||
              conversationId == null
          ? _value.conversationId
          // ignore: cast_nullable_to_non_nullable
          : conversationId as String,
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as IList<Message>,
      pending: pending == const $CopyWithPlaceholder() || pending == null
          ? _value.pending
          // ignore: cast_nullable_to_non_nullable
          : pending as IList<PendingMessage>,
      isLoading: isLoading == const $CopyWithPlaceholder() || isLoading == null
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
      isLoadingMore:
          isLoadingMore == const $CopyWithPlaceholder() || isLoadingMore == null
          ? _value.isLoadingMore
          // ignore: cast_nullable_to_non_nullable
          : isLoadingMore as bool,
      hasMore: hasMore == const $CopyWithPlaceholder() || hasMore == null
          ? _value.hasMore
          // ignore: cast_nullable_to_non_nullable
          : hasMore as bool,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as String?,
    );
  }
}

extension $MessageListStateCopyWith on MessageListState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMessageListState.copyWith(...)` or `instanceOfMessageListState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MessageListStateCWProxy get copyWith => _$MessageListStateCWProxyImpl(this);
}
