import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

import '../models/conversation.dart';
import '../models/message.dart';

part 'provider_event.g.dart';

sealed class ProviderEvent extends Equatable {
  const ProviderEvent();

  @override
  List<Object?> get props => [];
}

@CopyWith()
class NewMessageEvent extends ProviderEvent {
  final String conversationId;
  final Message message;

  const NewMessageEvent({required this.conversationId, required this.message});

  @override
  List<Object?> get props => [conversationId, message];
}

@CopyWith()
class MessageAckEvent extends ProviderEvent {
  final String clientMessageId;
  final String serverMessageId;
  final DateTime timestamp;

  const MessageAckEvent({required this.clientMessageId, required this.serverMessageId, required this.timestamp});

  @override
  List<Object?> get props => [clientMessageId, serverMessageId, timestamp];
}

@CopyWith()
class MessageFailedEvent extends ProviderEvent {
  final String clientMessageId;
  final String errorCode;

  const MessageFailedEvent({required this.clientMessageId, required this.errorCode});

  @override
  List<Object?> get props => [clientMessageId, errorCode];
}

@CopyWith()
class ConversationUpdatedEvent extends ProviderEvent {
  final Conversation conversation;

  const ConversationUpdatedEvent({required this.conversation});

  @override
  List<Object?> get props => [conversation];
}

class SessionExpiredEvent extends ProviderEvent {
  const SessionExpiredEvent();
}
