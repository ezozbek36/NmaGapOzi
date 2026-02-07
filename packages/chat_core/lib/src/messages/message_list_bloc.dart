import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:provider_api/provider_api.dart';
import 'package:uuid/uuid.dart';
import 'message_list_state.dart';
import 'pending_message.dart';
import 'send_message_use_case.dart';

abstract class MessageListEvent extends Equatable {
  const MessageListEvent();
  @override
  List<Object?> get props => [];
}

class MessageListLoadInitial extends MessageListEvent {}

class MessageListLoadEarlier extends MessageListEvent {}

class MessageListHandleNewMessage extends MessageListEvent {
  final Message message;
  const MessageListHandleNewMessage(this.message);
  @override
  List<Object?> get props => [message];
}

class MessageListSendMessage extends MessageListEvent {
  final String text;
  const MessageListSendMessage(this.text);
  @override
  List<Object?> get props => [text];
}

class MessageListHandleAck extends MessageListEvent {
  final String clientId;
  final String messageId;
  const MessageListHandleAck({required this.clientId, required this.messageId});
  @override
  List<Object?> get props => [clientId, messageId];
}

class MessageListHandleSendFailed extends MessageListEvent {
  final String clientId;
  final String error;
  const MessageListHandleSendFailed({required this.clientId, required this.error});
  @override
  List<Object?> get props => [clientId, error];
}

class MessageListRetryMessage extends MessageListEvent {
  final String clientId;
  const MessageListRetryMessage(this.clientId);
  @override
  List<Object?> get props => [clientId];
}

class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
  final IChatProvider _provider;
  final SendMessageUseCase _sendUseCase;

  MessageListBloc({required String conversationId, required IChatProvider provider, required SendMessageUseCase sendUseCase})
    : _provider = provider,
      _sendUseCase = sendUseCase,
      super(MessageListState(conversationId: conversationId)) {
    on<MessageListLoadInitial>(_onLoadInitial);
    on<MessageListLoadEarlier>(_onLoadEarlier);
    on<MessageListHandleNewMessage>(_onHandleNewMessage);
    on<MessageListSendMessage>(_onSendMessage);
    on<MessageListHandleAck>(_onHandleAck);
    on<MessageListHandleSendFailed>(_onHandleSendFailed);
    on<MessageListRetryMessage>(_onRetryMessage);
  }

  Future<void> _onLoadInitial(MessageListLoadInitial event, Emitter<MessageListState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final page = await _provider.listMessages(conversationId: state.conversationId, limit: 20);
      emit(state.copyWith(items: page.items.lock, isLoading: false, hasMore: page.hasMore));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadEarlier(MessageListLoadEarlier event, Emitter<MessageListState> emit) async {
    if (!state.hasMore || state.isLoadingMore || state.items.isEmpty) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final lastMsg = state.items.last;

      final page = await _provider.listMessages(conversationId: state.conversationId, beforeMessageId: lastMsg.id, limit: 20);

      emit(state.copyWith(items: state.items.addAll(page.items), isLoadingMore: false, hasMore: page.hasMore));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }

  Future<void> _onHandleNewMessage(MessageListHandleNewMessage event, Emitter<MessageListState> emit) async {
    if (event.message.conversationId != state.conversationId) return;

    final clientId = event.message.clientId;
    final existingIndex = clientId == null ? -1 : state.items.indexWhere((m) => m.clientId == clientId);
    final pending = clientId == null ? state.pending : _removePending(state.pending, clientId);

    if (existingIndex != -1) {
      emit(state.copyWith(items: state.items.replace(existingIndex, event.message), pending: pending));
    } else {
      emit(state.copyWith(items: state.items.insert(0, event.message), pending: pending));
    }
  }

  Future<void> _onSendMessage(MessageListSendMessage event, Emitter<MessageListState> emit) async {
    final clientId = Uuid().v4();
    final message = Message(
      id: clientId,
      conversationId: state.conversationId,
      senderLabel: 'Me',
      text: event.text,
      createdAt: DateTime.now(),
      direction: MessageDirection.outgoing,
      status: MessageStatus.sending,
      clientId: clientId,
    );
    final pendingMessage = PendingMessage(clientId: clientId, text: event.text, status: MessageStatus.sending);

    emit(state.copyWith(items: state.items.insert(0, message), pending: state.pending.insert(0, pendingMessage)));

    try {
      await _sendUseCase.send(conversationId: state.conversationId, text: event.text, clientId: clientId);
    } catch (e) {
      add(MessageListHandleSendFailed(clientId: clientId, error: e.toString()));
    }
  }

  Future<void> _onHandleAck(MessageListHandleAck event, Emitter<MessageListState> emit) async {
    final index = state.items.indexWhere((m) => m.clientId == event.clientId);
    final pending = _removePending(state.pending, event.clientId);
    if (index != -1) {
      final updatedMessage = state.items[index].copyWith(status: MessageStatus.sent, id: event.messageId);
      emit(state.copyWith(items: state.items.replace(index, updatedMessage), pending: pending));
      return;
    }
    emit(state.copyWith(pending: pending));
  }

  Future<void> _onHandleSendFailed(MessageListHandleSendFailed event, Emitter<MessageListState> emit) async {
    final messageIndex = state.items.indexWhere((m) => m.clientId == event.clientId);
    final pendingIndex = state.pending.indexWhere((m) => m.clientId == event.clientId);

    final updatedItems = messageIndex == -1
        ? state.items
        : state.items.replace(messageIndex, state.items[messageIndex].copyWith(status: MessageStatus.failed));

    final updatedPending = pendingIndex == -1
        ? state.pending
        : state.pending.replace(pendingIndex, state.pending[pendingIndex].copyWith(status: MessageStatus.failed, error: event.error));

    emit(state.copyWith(items: updatedItems, pending: updatedPending));
  }

  Future<void> _onRetryMessage(MessageListRetryMessage event, Emitter<MessageListState> emit) async {
    final messageIndex = state.items.indexWhere((m) => m.clientId == event.clientId);
    if (messageIndex == -1) return;

    final msg = state.items[messageIndex];
    final updatedItems = state.items.replace(messageIndex, msg.copyWith(status: MessageStatus.sending));

    final pendingIndex = state.pending.indexWhere((m) => m.clientId == event.clientId);
    final updatedPending = pendingIndex == -1
        ? _insertPendingByMessageOrder(
            pending: state.pending,
            items: state.items,
            messageIndex: messageIndex,
            message: PendingMessage(clientId: event.clientId, text: msg.text, status: MessageStatus.sending, retryCount: 1),
          )
        : state.pending.replace(
            pendingIndex,
            state.pending[pendingIndex].copyWith(
              status: MessageStatus.sending,
              retryCount: state.pending[pendingIndex].retryCount + 1,
              error: null,
            ),
          );

    emit(state.copyWith(items: updatedItems, pending: updatedPending));

    try {
      await _sendUseCase.retry(event.clientId, msg.conversationId, msg.text);
    } catch (e) {
      add(MessageListHandleSendFailed(clientId: event.clientId, error: e.toString()));
    }
  }

  IList<PendingMessage> _removePending(IList<PendingMessage> pending, String clientId) {
    return pending.where((m) => m.clientId != clientId).toIList();
  }

  IList<PendingMessage> _insertPendingByMessageOrder({
    required IList<PendingMessage> pending,
    required IList<Message> items,
    required int messageIndex,
    required PendingMessage message,
  }) {
    var insertAt = pending.length;

    for (var i = 0; i < pending.length; i++) {
      final currentIndex = items.indexWhere((m) => m.clientId == pending[i].clientId);
      if (currentIndex != -1 && currentIndex > messageIndex) {
        insertAt = i;
        break;
      }
    }

    return pending.insert(insertAt, message);
  }
}
