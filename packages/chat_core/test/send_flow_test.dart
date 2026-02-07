import 'dart:async';
import 'package:test/test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chat_core/chat_core.dart';
import 'package:provider_api/provider_api.dart';

class MockChatProvider extends Mock implements IChatProvider {
  final _controller = StreamController<ProviderEvent>.broadcast();
  @override
  Stream<ProviderEvent> get events => _controller.stream;

  void emit(ProviderEvent event) => _controller.add(event);

  void dispose() => _controller.close();
}

void main() {
  late MockChatProvider mockProvider;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(LoginParams(username: '', code: ''));
    registerFallbackValue(const Unauthenticated());
  });

  setUp(() {
    mockProvider = MockChatProvider();
    container = ProviderContainer(
      overrides: [
        chatProviderProvider.overrideWithValue(mockProvider),
        authBlocProvider.overrideWith((ref) => AuthBloc(provider: mockProvider)),
      ],
    );
    container.read(providerEventHandlerProvider);
  });

  tearDown(() {
    mockProvider.dispose();
    container.dispose();
  });

  test('send message with ack updates status', () async {
    final conversationId = 'conv-1';
    final text = 'Hello';

    when(
      () => mockProvider.listMessages(
        conversationId: any(named: 'conversationId'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => const MessagePage(items: [], hasMore: false));

    when(
      () => mockProvider.sendMessage(
        conversationId: any(named: 'conversationId'),
        clientMessageId: any(named: 'clientMessageId'),
        text: any(named: 'text'),
      ),
    ).thenAnswer((invocation) async {
      final clientId = invocation.namedArguments[#clientMessageId] as String;
      return SendResult(clientMessageId: clientId, accepted: true);
    });

    final subscription = container.listen(messageListBlocProvider(conversationId), (_, _) {});
    final bloc = container.read(messageListBlocProvider(conversationId));

    bloc.add(MessageListSendMessage(text));
    await Future.delayed(Duration.zero);

    expect(bloc.state.items, isNotEmpty);
    expect(bloc.state.items.first.status, MessageStatus.sending);
    final clientId = bloc.state.items.first.clientId!;
    expect(bloc.state.pending.first.clientId, clientId);
    expect(bloc.state.pending.first.status, MessageStatus.sending);

    mockProvider.emit(MessageAckEvent(clientMessageId: clientId, serverMessageId: 'server-1', timestamp: DateTime.now()));
    await Future.delayed(const Duration(milliseconds: 100));

    expect(bloc.state.items.first.status, MessageStatus.sent);
    expect(bloc.state.items.first.id, 'server-1');
    expect(bloc.state.pending, isEmpty);

    subscription.close();
  });

  test('send message failure updates status', () async {
    final conversationId = 'conv-fail';
    final text = 'Hello Fail';

    when(
      () => mockProvider.listMessages(
        conversationId: any(named: 'conversationId'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => const MessagePage(items: [], hasMore: false));

    when(
      () => mockProvider.sendMessage(
        conversationId: any(named: 'conversationId'),
        clientMessageId: any(named: 'clientMessageId'),
        text: any(named: 'text'),
      ),
    ).thenAnswer((invocation) async {
      final clientId = invocation.namedArguments[#clientMessageId] as String;
      return SendResult(clientMessageId: clientId, accepted: false, error: 'Network Error');
    });

    final subscription = container.listen(messageListBlocProvider(conversationId), (_, _) {});
    final bloc = container.read(messageListBlocProvider(conversationId));

    bloc.add(MessageListSendMessage(text));

    await Future.delayed(const Duration(milliseconds: 100));

    expect(bloc.state.items.first.status, MessageStatus.failed);
    expect(bloc.state.pending.first.status, MessageStatus.failed);

    subscription.close();
  });

  test('retry message updates status and accepts ack', () async {
    final conversationId = 'conv-retry';
    final text = 'Hello Retry';
    var sendCount = 0;

    when(
      () => mockProvider.listMessages(
        conversationId: any(named: 'conversationId'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => const MessagePage(items: [], hasMore: false));

    when(
      () => mockProvider.sendMessage(
        conversationId: any(named: 'conversationId'),
        clientMessageId: any(named: 'clientMessageId'),
        text: any(named: 'text'),
      ),
    ).thenAnswer((invocation) async {
      final clientId = invocation.namedArguments[#clientMessageId] as String;
      sendCount += 1;
      if (sendCount == 1) {
        return SendResult(clientMessageId: clientId, accepted: false, error: 'Network Error');
      }
      return SendResult(clientMessageId: clientId, accepted: true);
    });

    final subscription = container.listen(messageListBlocProvider(conversationId), (_, _) {});
    final bloc = container.read(messageListBlocProvider(conversationId));

    bloc.add(MessageListSendMessage(text));
    await Future.delayed(const Duration(milliseconds: 100));

    final clientId = bloc.state.items.first.clientId!;
    expect(bloc.state.items.first.status, MessageStatus.failed);
    expect(bloc.state.pending.first.clientId, clientId);
    expect(bloc.state.pending.first.status, MessageStatus.failed);

    bloc.add(MessageListRetryMessage(clientId));
    await Future.delayed(const Duration(milliseconds: 100));

    expect(bloc.state.items.first.status, MessageStatus.sending);
    expect(bloc.state.pending.first.status, MessageStatus.sending);
    expect(bloc.state.pending.first.retryCount, 1);

    mockProvider.emit(MessageAckEvent(clientMessageId: clientId, serverMessageId: 'server-retry', timestamp: DateTime.now()));
    await Future.delayed(const Duration(milliseconds: 100));

    expect(bloc.state.items.first.status, MessageStatus.sent);
    expect(bloc.state.items.first.id, 'server-retry');
    expect(bloc.state.pending, isEmpty);

    subscription.close();
  });
}
