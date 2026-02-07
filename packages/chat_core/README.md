# chat_core

The core business logic package for the NmaGapOZi chat application.

## Features

- **Authentication**: `AuthBloc` for managing user sessions and login/logout flows.
- **Conversations**: `ConversationListBloc` for paginated conversation lists, searching, and real-time updates.
- **Messages**: `MessageListBloc` for paginated message history, optimistic sending, and delivery status tracking.
- **State Management**: Built with `bloc` for logic and `flutter_riverpod` for dependency injection.
- **Provider Integration**: `ProviderEventHandler` to bridge low-level `IChatProvider` events to UI state.

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  chat_core:
    path: packages/chat_core
```

## Usage

Override `chatProviderProvider` in your Riverpod `ProviderScope` to provide a concrete implementation of `IChatProvider`.

```dart
ProviderScope(
  overrides: [
    chatProviderProvider.overrideWithValue(MyChatProvider()),
  ],
  child: MyApp(),
)
```

Access blocs via the provided Riverpod providers:

```dart
final authBloc = ref.watch(authBlocProvider);
final conversationListBloc = ref.watch(conversationListBlocProvider);
```
