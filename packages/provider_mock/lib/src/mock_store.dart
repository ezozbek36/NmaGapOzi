import 'package:provider_api/provider_api.dart';

class MockStore {
  final Map<String, Conversation> conversations = {};
  final Map<String, List<Message>> messages = {}; // key: conversationId
  ProviderSession? session;

  void clear() {
    conversations.clear();
    messages.clear();
    session = null;
  }
}
