import 'dart:async';
import 'package:provider_api/provider_api.dart';
import '../auth/auth_bloc.dart';
import '../messages/message_list_bloc.dart';
import '../conversations/conversation_list_bloc.dart';

class ProviderEventHandler {
  final AuthBloc authBloc;
  final IChatProvider _provider;
  final Map<String, MessageListBloc> _activeMessageBlocs = {};
  ConversationListBloc? _conversationListBloc;
  StreamSubscription? _subscription;

  ProviderEventHandler({required this.authBloc, required IChatProvider provider}) : _provider = provider;

  void registerMessageBloc(String conversationId, MessageListBloc bloc) {
    _activeMessageBlocs[conversationId] = bloc;
  }

  void unregisterMessageBloc(String conversationId) {
    _activeMessageBlocs.remove(conversationId);
  }

  void registerConversationListBloc(ConversationListBloc bloc) {
    _conversationListBloc = bloc;
  }

  void unregisterConversationListBloc() {
    _conversationListBloc = null;
  }

  void start() {
    _subscription?.cancel();
    _subscription = _provider.events.listen(_handleEvent);
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _handleEvent(ProviderEvent event) {
    if (event is NewMessageEvent) {
      final bloc = _activeMessageBlocs[event.conversationId];
      if (bloc != null) {
        bloc.add(MessageListHandleNewMessage(event.message));
      }
      return;
    }

    if (event is MessageAckEvent) {
      for (var bloc in _activeMessageBlocs.values) {
        bloc.add(MessageListHandleAck(clientId: event.clientMessageId, messageId: event.serverMessageId));
      }
      return;
    }

    if (event is MessageFailedEvent) {
      for (var bloc in _activeMessageBlocs.values) {
        bloc.add(MessageListHandleSendFailed(clientId: event.clientMessageId, error: event.errorCode));
      }
      return;
    }

    if (event is ConversationUpdatedEvent) {
      _conversationListBloc?.add(ConversationListHandleUpdate(event.conversation));
      return;
    }

    if (event is SessionExpiredEvent) {
      authBloc.add(AuthLogout());
    }
  }
}
