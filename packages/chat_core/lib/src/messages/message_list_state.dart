import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:provider_api/provider_api.dart';
import 'pending_message.dart';

part 'message_list_state.g.dart';

@CopyWith()
class MessageListState extends Equatable {
  final String conversationId;
  final IList<Message> items;
  final IList<PendingMessage> pending;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;

  const MessageListState({
    required this.conversationId,
    this.items = const IListConst([]),
    this.pending = const IListConst([]),
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.error,
  });

  @override
  List<Object?> get props => [conversationId, items, pending, isLoading, isLoadingMore, hasMore, error];
}
