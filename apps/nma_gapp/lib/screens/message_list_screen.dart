import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_core/chat_core.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:provider_api/provider_api.dart';

class MessageListScreen extends ConsumerWidget {
  const MessageListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final selectedId = ref.watch(selectedConversationIdProvider);

    if (selectedId == null) {
      return Center(child: Text('No conversation selected', style: theme.typography.muted));
    }

    final bloc = ref.watch(messageListBlocProvider(selectedId));

    return Container(
      color: theme.colors.background,
      child: BlocBuilder<MessageListBloc, MessageListState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.items.isEmpty && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: theme.colors.border)),
                  color: theme.colors.surface,
                ),
                child: Row(children: [Text('Conversation', style: theme.typography.h3)]),
              ),
              Expanded(
                child: SuperListView(
                  reverse: true,
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final message = state.items[index];
                    final isMe = message.direction == MessageDirection.outgoing;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? theme.colors.accent : theme.colors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.colors.border),
                        ),
                        child: Text(
                          message.text,
                          style: theme.typography.p.copyWith(color: isMe ? theme.colors.accentForeground : theme.colors.foreground),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
