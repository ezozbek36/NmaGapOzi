import 'package:provider_api/provider_api.dart';
import 'package:provider_mock/provider_mock.dart';
import 'package:test/test.dart';

void main() {
  test('send message triggers ack event', () async {
    const config = MockProviderConfig(seed: 42, latencyMinMs: 10, latencyMaxMs: 20);
    final provider = MockChatProvider(config: config);
    await provider.login(const LoginParams(username: 'test', code: '123'));

    final clientId = 'client-123';

    // We expect at least MessageAckEvent.
    // Also likely NewMessageEvent and ConversationUpdatedEvent.

    final futureAck = provider.events.where((e) => e is MessageAckEvent).first;

    await provider.sendMessage(conversationId: 'conv-1', clientMessageId: clientId, text: 'Hello');

    final event = await futureAck;
    expect(event, isA<MessageAckEvent>());
    expect((event as MessageAckEvent).clientMessageId, equals(clientId));
  });
}
