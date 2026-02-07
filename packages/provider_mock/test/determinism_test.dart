import 'package:test/test.dart';
import 'package:provider_mock/provider_mock.dart';

void main() {
  test('same seed produces same data', () async {
    final fixedTime = DateTime(2025, 1, 1);
    final config = MockProviderConfig(seed: 42, latencyMinMs: 0, latencyMaxMs: 0, baseTime: fixedTime);
    final provider1 = MockChatProvider(config: config);
    final provider2 = MockChatProvider(config: config);

    final convs1 = await provider1.listConversations();

    final convs2 = await provider2.listConversations();

    expect(convs1.items, equals(convs2.items));
    expect(convs1.items.length, equals(config.conversationCount));
  });
}
