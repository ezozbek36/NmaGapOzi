import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';

@CopyWith()
@JsonSerializable()
class Conversation extends Equatable {
  final String id;
  final String title;
  final String? lastMessageSnippet;
  final int unreadCount;
  final DateTime updatedAt;
  final bool pinned;

  const Conversation({
    required this.id,
    required this.title,
    this.lastMessageSnippet,
    required this.unreadCount,
    required this.updatedAt,
    required this.pinned,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  @override
  List<Object?> get props => [id, title, lastMessageSnippet, unreadCount, updatedAt, pinned];
}
