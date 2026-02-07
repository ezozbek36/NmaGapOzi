import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_core/chat_core.dart';
import 'package:ui_kit/ui_kit.dart';

class MessageComposer extends ConsumerStatefulWidget {
  const MessageComposer({super.key});

  @override
  ConsumerState<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends ConsumerState<MessageComposer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final conversationId = ref.read(selectedConversationIdProvider);
    if (conversationId == null) return;

    final messageListBloc = ref.read(messageListBlocProvider(conversationId));

    messageListBloc.add(MessageListSendMessage(text));

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final selectedId = ref.watch(selectedConversationIdProvider);

    if (selectedId == null) {
      return const SizedBox.shrink();
    }

    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.background,
          border: Border(top: BorderSide(color: theme.colors.border)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: theme.typography.p,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: theme.typography.muted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: theme.colors.border),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  filled: true,
                  fillColor: theme.colors.surface,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(onPressed: _sendMessage, icon: Icons.send, size: 24),
          ],
        ),
      ),
    );
  }
}
