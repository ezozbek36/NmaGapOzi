import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

enum MessageDirection { incoming, outgoing }

enum MessageStatus { sending, sent, failed }

@CopyWith()
@JsonSerializable()
class Message extends Equatable {
  final String id;
  final String conversationId;
  final String senderLabel;
  final String text;
  final DateTime createdAt;
  final MessageDirection direction;
  final MessageStatus status;
  final String? clientId;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderLabel,
    required this.text,
    required this.createdAt,
    required this.direction,
    required this.status,
    this.clientId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object?> get props => [id, conversationId, senderLabel, text, createdAt, direction, status, clientId];
}
