import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_core/chat_core.dart';
import 'package:ui_kit/ui_kit.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final bloc = ref.watch(conversationListBlocProvider);
    final selectedId = ref.watch(selectedConversationIdProvider);

    return Container(
      color: theme.colors.muted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Conversations', style: theme.typography.h3),
          ),
          Expanded(
            child: BlocBuilder<ConversationListBloc, ConversationListState>(
              bloc: bloc,
              builder: (context, state) {
                if (state.isLoading && state.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error != null && state.items.isEmpty) {
                  return Center(
                    child: Text('Error: ${state.error}', style: theme.typography.p.copyWith(color: theme.colors.destructive)),
                  );
                }

                if (state.items.isEmpty) {
                  return Center(child: Text('No conversations', style: theme.typography.muted));
                }

                return SuperListView(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final conversation = state.items[index];
                    final isSelected = conversation.id == selectedId;

                    return ListItem(
                      title: Text(
                        conversation.title,
                        style: theme.typography.p.copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        conversation.lastMessageSnippet ?? '',
                        style: theme.typography.small,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: Avatar(imageUrl: null, initials: conversation.title.isNotEmpty ? conversation.title[0] : '?', size: 40),
                      selected: isSelected,
                      onTap: () {
                        ref.read(selectedConversationIdProvider.notifier).select(conversation.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
