import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:provider_api/provider_api.dart';

part 'conversation_list_state.g.dart';

@CopyWith()
class ConversationListState extends Equatable {
  final List<Conversation> items;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final String? searchQuery;

  const ConversationListState({this.items = const [], this.isLoading = false, this.hasMore = true, this.error, this.searchQuery});

  @override
  List<Object?> get props => [items, isLoading, hasMore, error, searchQuery];
}
