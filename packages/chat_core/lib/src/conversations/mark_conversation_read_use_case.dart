import 'package:provider_api/provider_api.dart';

class MarkConversationReadUseCase {
  final IChatProvider _provider;

  MarkConversationReadUseCase(this._provider);

  Future<void> execute(String conversationId) async {
    await _provider.markAsRead(conversationId);
  }
}
