import 'package:bloc_test/bloc_test.dart';
import 'package:chat_core/chat_core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider_api/provider_api.dart';
import 'package:test/test.dart';

class MockChatProvider extends Mock implements IChatProvider {}

class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}

Message _message({
  required String id,
  required String conversationId,
  required String text,
  MessageStatus status = MessageStatus.sent,
  String? clientId,
}) {
  return Message(
    id: id,
    conversationId: conversationId,
    senderLabel: 'User',
    text: text,
    createdAt: DateTime.now(),
    direction: MessageDirection.incoming,
    status: status,
    clientId: clientId,
  );
}

void main() {
  late MockChatProvider mockProvider;
  late MockSendMessageUseCase mockSendUseCase;

  setUp(() {
    mockProvider = MockChatProvider();
    mockSendUseCase = MockSendMessageUseCase();
  });

  group('MessageListBloc', () {
    blocTest<MessageListBloc, MessageListState>(
      'loads initial messages',
      build: () {
        when(
          () => mockProvider.listMessages(
            conversationId: any(named: 'conversationId'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) async => MessagePage(
            items: [_message(id: 'm1', conversationId: 'c1', text: 'hello')],
            hasMore: true,
          ),
        );

        return MessageListBloc(conversationId: 'c1', provider: mockProvider, sendUseCase: mockSendUseCase);
      },
      act: (bloc) => bloc.add(MessageListLoadInitial()),
      expect: () => [
        const MessageListState(conversationId: 'c1', isLoading: true),
        isA<MessageListState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.items.length, 'items length', 1)
            .having((s) => s.hasMore, 'hasMore', true),
      ],
    );

    blocTest<MessageListBloc, MessageListState>(
      'load earlier appends older messages',
      build: () {
        when(
          () => mockProvider.listMessages(
            conversationId: any(named: 'conversationId'),
            beforeMessageId: any(named: 'beforeMessageId'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) async => MessagePage(
            items: [_message(id: 'm0', conversationId: 'c1', text: 'older')],
            hasMore: false,
          ),
        );

        return MessageListBloc(conversationId: 'c1', provider: mockProvider, sendUseCase: mockSendUseCase);
      },
      seed: () => MessageListState(
        conversationId: 'c1',
        items: [_message(id: 'm1', conversationId: 'c1', text: 'newer')].lock,
        hasMore: true,
      ),
      act: (bloc) => bloc.add(MessageListLoadEarlier()),
      expect: () => [
        isA<MessageListState>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
        isA<MessageListState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.items.length, 'items length', 2)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<MessageListBloc, MessageListState>(
      'incoming message replaces optimistic message with same clientId',
      build: () => MessageListBloc(conversationId: 'c1', provider: mockProvider, sendUseCase: mockSendUseCase),
      seed: () => MessageListState(
        conversationId: 'c1',
        items: [_message(id: 'tmp-1', conversationId: 'c1', text: 'hello', status: MessageStatus.sending, clientId: 'client-1')].lock,
        pending: const [PendingMessage(clientId: 'client-1', text: 'hello', status: MessageStatus.sending)].lock,
      ),
      act: (bloc) {
        bloc.add(
          MessageListHandleNewMessage(
            Message(
              id: 'server-1',
              conversationId: 'c1',
              senderLabel: 'Me',
              text: 'hello',
              createdAt: DateTime.now(),
              direction: MessageDirection.outgoing,
              status: MessageStatus.sent,
              clientId: 'client-1',
            ),
          ),
        );
      },
      expect: () => [
        isA<MessageListState>()
            .having((s) => s.items.first.id, 'message id', 'server-1')
            .having((s) => s.items.first.status, 'status', MessageStatus.sent)
            .having((s) => s.pending, 'pending', isEmpty),
      ],
    );

    blocTest<MessageListBloc, MessageListState>(
      'retry inserts missing pending item by message order',
      build: () {
        when(() => mockSendUseCase.retry('client-retry', 'c1', 'retry')).thenAnswer((_) async {});

        return MessageListBloc(conversationId: 'c1', provider: mockProvider, sendUseCase: mockSendUseCase);
      },
      seed: () => MessageListState(
        conversationId: 'c1',
        items: [
          _message(id: 'tmp-new', conversationId: 'c1', text: 'new', status: MessageStatus.sending, clientId: 'client-new'),
          _message(id: 'tmp-retry', conversationId: 'c1', text: 'retry', status: MessageStatus.failed, clientId: 'client-retry'),
          _message(id: 'tmp-old', conversationId: 'c1', text: 'old', status: MessageStatus.failed, clientId: 'client-old'),
        ].lock,
        pending: const [
          PendingMessage(clientId: 'client-new', text: 'new', status: MessageStatus.sending),
          PendingMessage(clientId: 'client-old', text: 'old', status: MessageStatus.failed),
        ].lock,
      ),
      act: (bloc) => bloc.add(const MessageListRetryMessage('client-retry')),
      expect: () => [
        isA<MessageListState>()
            .having((s) => s.pending.map((p) => p.clientId).toList(), 'pending order', ['client-new', 'client-retry', 'client-old'])
            .having((s) => s.pending[1].status, 'retry status', MessageStatus.sending)
            .having((s) => s.pending[1].retryCount, 'retry count', 1),
      ],
    );
  });
}
