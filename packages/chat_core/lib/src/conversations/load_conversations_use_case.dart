import 'package:provider_api/provider_api.dart';

class LoadConversationsUseCase {
  final IChatProvider _provider;

  LoadConversationsUseCase(this._provider);

  Future<ConversationPage> execute({String? cursor, int limit = 50, String? query}) async {
    final page = await _provider.listConversations(cursor: cursor, limit: limit, query: query);

    // Client-side sorting: pinned first, then updatedAt descending
    final sortedItems = List<Conversation>.from(page.items);
    sortedItems.sort((a, b) {
      if (a.pinned != b.pinned) {
        return a.pinned ? -1 : 1;
      }
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return page.copyWith(items: sortedItems);
  }
}
