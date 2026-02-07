# provider_api

Defines the abstract interface and domain models for chat providers in the NmaGapOS ecosystem. This package is the contract that concrete provider implementations (Telegram, WhatsApp, etc.) must follow.

## Features

- `IChatProvider` interface for auth, conversations, messages, sending, and live events.
- Immutable domain models with value equality via `equatable`.
- Generated `copyWith` methods via `copy_with_extension`.
- JSON serialization via `json_serializable`/`json_annotation`.
- Sealed provider event hierarchy and standardized provider exceptions.

## Architecture

- **Contract**: `IChatProvider` in `lib/src/provider.dart`
- **Models**: `Conversation`, `Message`, `ProviderSession`, `ConversationPage`, `MessagePage`, `SendResult`, `LoginParams`
- **Enums**: `MessageDirection`, `MessageStatus`
- **Events**: `ProviderEvent` with concrete classes like `NewMessageEvent`, `MessageAckEvent`
- **Exceptions**: `ProviderException`, `AuthenticationException`, `NetworkException`, `RateLimitException`

## Usage

### Implementing a provider

```dart
import 'package:provider_api/provider_api.dart';

class MyChatProvider implements IChatProvider {
  @override
  ProviderSession? get currentSession => null;

  @override
  Stream<ProviderEvent> get events => const Stream.empty();

  @override
  Future<ProviderSession?> restoreSession() async => null;

  @override
  Future<ProviderSession> login(LoginParams params) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<ConversationPage> listConversations({String? cursor, int limit = 50, String? query}) {
    throw UnimplementedError();
  }

  @override
  Future<MessagePage> listMessages({required String conversationId, String? beforeMessageId, int limit = 50}) {
    throw UnimplementedError();
  }

  @override
  Future<SendResult> sendMessage({required String conversationId, required String clientMessageId, required String text}) {
    throw UnimplementedError();
  }
}
```

### Models, JSON, and copyWith

```dart
import 'package:provider_api/provider_api.dart';

final message = Message(
  id: '123',
  conversationId: 'conv_1',
  senderLabel: 'Alice',
  text: 'Hello world',
  createdAt: DateTime.now(),
  direction: MessageDirection.incoming,
  status: MessageStatus.sending,
);

final sentMessage = message.copyWith(status: MessageStatus.sent);
final json = sentMessage.toJson();
final restored = Message.fromJson(json);
```

### Events

```dart
import 'package:provider_api/provider_api.dart';

final event = NewMessageEvent(
  conversationId: 'conv_1',
  message: Message(
    id: 'm1',
    conversationId: 'conv_1',
    senderLabel: 'Alice',
    text: 'Hi',
    createdAt: DateTime.now(),
    direction: MessageDirection.incoming,
    status: MessageStatus.sent,
  ),
);
```
