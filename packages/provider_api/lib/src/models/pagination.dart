import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'conversation.dart';
import 'message.dart';

part 'pagination.g.dart';

@CopyWith()
@JsonSerializable()
class ConversationPage extends Equatable {
  final List<Conversation> items;
  final String? nextCursor;
  final bool hasMore;

  const ConversationPage({required this.items, this.nextCursor, required this.hasMore});

  factory ConversationPage.fromJson(Map<String, dynamic> json) => _$ConversationPageFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationPageToJson(this);

  @override
  List<Object?> get props => [items, nextCursor, hasMore];
}

@CopyWith()
@JsonSerializable()
class MessagePage extends Equatable {
  final List<Message> items;
  final bool hasMore;

  const MessagePage({required this.items, required this.hasMore});

  factory MessagePage.fromJson(Map<String, dynamic> json) => _$MessagePageFromJson(json);

  Map<String, dynamic> toJson() => _$MessagePageToJson(this);

  @override
  List<Object?> get props => [items, hasMore];
}
