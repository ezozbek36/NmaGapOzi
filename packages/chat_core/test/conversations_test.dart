import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_core/src/conversations/mark_conversation_read_use_case.dart';
import 'package:provider_api/provider_api.dart';

class MockLoadConversationsUseCase extends Mock implements LoadConversationsUseCase {}

class MockMarkConversationReadUseCase extends Mock implements MarkConversationReadUseCase {}

void main() {
  late MockLoadConversationsUseCase mockLoadUseCase;
  late MockMarkConversationReadUseCase mockMarkReadUseCase;

  setUp(() {
    mockLoadUseCase = MockLoadConversationsUseCase();
    mockMarkReadUseCase = MockMarkConversationReadUseCase();
  });

  group('ConversationListBloc', () {
    final conversation = Conversation(id: 'c1', title: 'Chat', unreadCount: 1, updatedAt: DateTime.now(), pinned: false);

    blocTest<ConversationListBloc, ConversationListState>(
      'loads initial conversations',
      build: () => ConversationListBloc(loadUseCase: mockLoadUseCase, markReadUseCase: mockMarkReadUseCase),
      act: (bloc) {
        when(
          () => mockLoadUseCase.execute(
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async => ConversationPage(items: [conversation], hasMore: false));
        bloc.add(ConversationListLoadInitial());
      },
      expect: () => [
        const ConversationListState(isLoading: true),
        ConversationListState(isLoading: false, items: [conversation], hasMore: false),
      ],
    );

    blocTest<ConversationListBloc, ConversationListState>(
      'select conversation marks it as read',
      build: () => ConversationListBloc(loadUseCase: mockLoadUseCase, markReadUseCase: mockMarkReadUseCase),
      seed: () => ConversationListState(items: [conversation]),
      act: (bloc) {
        when(() => mockMarkReadUseCase.execute(any())).thenAnswer((_) async {});
        bloc.add(ConversationListSelect('c1'));
      },
      expect: () => [
        ConversationListState(items: [conversation.copyWith(unreadCount: 0)]),
      ],
      verify: (_) {
        verify(() => mockMarkReadUseCase.execute('c1')).called(1);
      },
    );

    blocTest<ConversationListBloc, ConversationListState>(
      'handle update updates existing conversation',
      build: () => ConversationListBloc(loadUseCase: mockLoadUseCase, markReadUseCase: mockMarkReadUseCase),
      seed: () => ConversationListState(items: [conversation]),
      act: (bloc) {
        final updated = conversation.copyWith(unreadCount: 2, lastMessageSnippet: 'New');
        bloc.add(ConversationListHandleUpdate(updated));
      },
      expect: () => [
        ConversationListState(items: [conversation.copyWith(unreadCount: 2, lastMessageSnippet: 'New')]),
      ],
    );
  });
}
