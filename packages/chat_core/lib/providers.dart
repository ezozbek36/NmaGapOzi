import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_api/provider_api.dart';
import 'package:rxdart/rxdart.dart';
import 'chat_core.dart';
import 'src/conversations/mark_conversation_read_use_case.dart';

final chatProviderProvider = Provider<IChatProvider>((ref) {
  throw UnimplementedError('chatProviderProvider must be overridden');
});

final authBlocProvider = Provider<AuthBloc>((ref) {
  final bloc = AuthBloc(provider: ref.watch(chatProviderProvider));
  bloc.add(AuthCheckStatus());
  return bloc;
});

final loadConversationsUseCaseProvider = Provider<LoadConversationsUseCase>((ref) {
  return LoadConversationsUseCase(ref.watch(chatProviderProvider));
});

final markConversationReadUseCaseProvider = Provider<MarkConversationReadUseCase>((ref) {
  return MarkConversationReadUseCase(ref.watch(chatProviderProvider));
});

final conversationListBlocProvider = Provider.autoDispose<ConversationListBloc>((ref) {
  final bloc = ConversationListBloc(
    loadUseCase: ref.watch(loadConversationsUseCaseProvider),
    markReadUseCase: ref.watch(markConversationReadUseCaseProvider),
  )..add(ConversationListLoadInitial());

  final handler = ref.read(providerEventHandlerProvider);
  handler.registerConversationListBloc(bloc);

  ref.onDispose(() {
    handler.unregisterConversationListBloc();
    bloc.close();
  });

  return bloc;
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.watch(chatProviderProvider));
});

final messageListBlocProvider = Provider.family.autoDispose<MessageListBloc, String>((ref, conversationId) {
  final bloc = MessageListBloc(
    conversationId: conversationId,
    provider: ref.watch(chatProviderProvider),
    sendUseCase: ref.watch(sendMessageUseCaseProvider),
  )..add(MessageListLoadInitial());

  final handler = ref.read(providerEventHandlerProvider);
  handler.registerMessageBloc(conversationId, bloc);

  ref.onDispose(() {
    handler.unregisterMessageBloc(conversationId);
    bloc.close();
  });

  return bloc;
});

final providerEventHandlerProvider = Provider<ProviderEventHandler>((ref) {
  final handler = ProviderEventHandler(authBloc: ref.watch(authBlocProvider), provider: ref.watch(chatProviderProvider));
  handler.start();
  ref.onDispose(() => handler.stop());
  return handler;
});

class SelectedConversationIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

final selectedConversationIdProvider = NotifierProvider<SelectedConversationIdNotifier, String?>(SelectedConversationIdNotifier.new);

final selectedConversationMessagesProvider = StreamProvider.autoDispose<MessageListState>((ref) {
  final selectedId = ref.watch(selectedConversationIdProvider);
  if (selectedId == null) {
    return Stream.value(const MessageListState(conversationId: ''));
  }
  final bloc = ref.watch(messageListBlocProvider(selectedId));
  return bloc.stream.startWith(bloc.state);
});
