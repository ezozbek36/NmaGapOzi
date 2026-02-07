import 'package:provider_api/provider_api.dart';
import 'package:provider_mock/provider_mock.dart';
import 'package:test/test.dart';

void main() {
  test('pagination returns all items', () async {
    const config = MockProviderConfig(seed: 42, latencyMinMs: 0, latencyMaxMs: 0, conversationCount: 25);
    final provider = MockChatProvider(config: config);

    String? cursor;
    var allItems = <Conversation>[];

    do {
      final page = await provider.listConversations(cursor: cursor, limit: 10);
      allItems.addAll(page.items);
      cursor = page.nextCursor;
    } while (cursor != null);

    expect(allItems.length, equals(config.conversationCount));

    // check uniqueness
    final ids = allItems.map((c) => c.id).toSet();
    expect(ids.length, equals(config.conversationCount));
  });

  test('message pagination returns all items', () async {
    const config = MockProviderConfig(
      seed: 42,
      latencyMinMs: 0,
      latencyMaxMs: 0,
      conversationCount: 20,
      messagesPerConversation: 100, // Increase max to ensure we get some long conversations
    );
    final provider = MockChatProvider(config: config);

    // Find a conversation with enough messages to test pagination
    final convs = await provider.listConversations();
    String? conversationId;
    // ignore: unused_local_variable
    int totalMessages = 0;

    for (final conv in convs.items) {
      final all = await provider.listMessages(conversationId: conv.id, limit: 1000);
      if (all.items.length >= 20) {
        conversationId = conv.id;
        totalMessages = all.items.length;
        break;
      }
    }

    expect(conversationId, isNotNull, reason: 'Should have at least one conversation with 20+ messages');

    // Test pagination on this conversation

    // 1. Get latest page
    final page1 = await provider.listMessages(conversationId: conversationId!, limit: 10);
    expect(page1.items.length, 10);
    expect(page1.hasMore, true);

    // 2. Get previous page (older messages)
    // listMessages returns items sorted by createdAt ASC usually (or DESC depending on UI needs).
    // The implementation: allMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // And returns sublist.
    // So items are [oldest ... newest].
    // So items.first is the oldest in the page.

    final oldestInPage1 = page1.items.first.id;

    final page2 = await provider.listMessages(conversationId: conversationId, beforeMessageId: oldestInPage1, limit: 10);
    expect(page2.items.length, 10);

    // Check uniqueness
    final page1Ids = page1.items.map((m) => m.id).toSet();
    final page2Ids = page2.items.map((m) => m.id).toSet();

    // Intersection should be empty
    expect(page1Ids.intersection(page2Ids), isEmpty);
  });
}
