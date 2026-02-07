# Provider Mock

A deterministic mock implementation of the `provider_api` for testing and development.

## Features

- **Deterministic Data Generation:** seeded random generator for consistent test data.
- **In-Memory Storage:** fast and ephemeral data store.
- **Network Simulation:** configurable latency and failure rates.
- **Pagination Support:** full support for cursor-based pagination.
- **Event Simulation:** optimistic updates and message acknowledgments.

## Usage

```dart
import 'package:provider_api/provider_api.dart';
import 'package:provider_mock/provider_mock.dart';

void main() async {
  // Configure the mock
  final config = MockProviderConfig(
    seed: 12345,
    conversationCount: 20,
    latencyMinMs: 500,
    latencyMaxMs: 1000,
    failRate: 0.1, // 10% chance of failure
  );

  // Initialize the provider
  final provider = MockChatProvider(config: config);

  // Use the provider
  final conversations = await provider.listConversations();
  print('Loaded ${conversations.items.length} conversations');

  // Send a message
  await provider.login(LoginParams(username: 'Alice', code: '0000'));
  await provider.sendMessage(
    conversationId: conversations.items.first.id,
    clientMessageId: 'temp-1',
    text: 'Hello World',
  );
}
```

## Configuration

The `MockProviderConfig` allows you to customize the simulation:

- `seed`: Seed for random number generator.
- `conversationCount`: Number of conversations to generate.
- `messagesPerConversation`: Approximate messages per conversation.
- `latencyMinMs` / `latencyMaxMs`: Network delay simulation.
- `failRate`: Probability of network errors (0.0 to 1.0).
- `baseTime`: Optional fixed time for completely deterministic timestamps.
