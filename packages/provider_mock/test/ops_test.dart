import 'package:provider_api/provider_api.dart';
import 'package:provider_mock/provider_mock.dart';
import 'package:test/test.dart';

void main() {
  test('markAsRead clears unread count and emits update', () async {
    const config = MockProviderConfig(seed: 42, latencyMinMs: 0, latencyMaxMs: 0);
    final provider = MockChatProvider(config: config);

    // Find a conversation with unread messages
    final convs = await provider.listConversations();
    final conversation = convs.items.firstWhere((c) => c.unreadCount > 0);

    // Expect an event
    final futureUpdate = provider.events.where((e) => e is ConversationUpdatedEvent).first;

    await provider.markAsRead(conversation.id);

    final event = await futureUpdate;
    expect(event, isA<ConversationUpdatedEvent>());

    final updatedConv = (event as ConversationUpdatedEvent).conversation;
    expect(updatedConv.id, equals(conversation.id));
    expect(updatedConv.unreadCount, equals(0));

    // Verify persistence in store
    final newConvs = await provider.listConversations();
    final storedConv = newConvs.items.firstWhere((c) => c.id == conversation.id);
    expect(storedConv.unreadCount, equals(0));
  });
}
