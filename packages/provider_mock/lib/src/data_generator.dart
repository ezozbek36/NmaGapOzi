import 'dart:math';

import 'package:provider_api/provider_api.dart';

import 'mock_config.dart';
import 'mock_store.dart';

class MockDataGenerator {
  final MockProviderConfig config;
  final MockStore store;
  late final Random _random;

  MockDataGenerator(this.config, this.store) {
    _random = Random(config.seed);
  }

  static const _names = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Eve',
    'Frank',
    'Grace',
    'Heidi',
    'Ivan',
    'Judy',
    'Mallory',
    'Oscar',
    'Peggy',
    'Sybil',
    'Trent',
    'Walter',
  ];

  static const _sentences = [
    'Hello there!',
    'How are you doing today?',
    'Did you see the game last night?',
    'Can we meet at 5 PM?',
    'Please check the document I sent.',
    'Thanks for your help!',
    'Okay, sounds good to me.',
    'Where is the cat?',
    'Lorem ipsum dolor sit amet.',
    'The quick brown fox jumps over the lazy dog.',
    'I will be late, sorry.',
    'Let me know when you are free.',
    'This is a test message.',
    'Flutter is awesome!',
    'Deterministic generation is cool.',
  ];

  void generate() {
    store.clear();

    final now = config.baseTime ?? DateTime.now();

    for (int i = 0; i < config.conversationCount; i++) {
      final conversationId = 'conv-$i';
      final title = _names[_random.nextInt(_names.length)];
      final isPinned = i < 3; // Pin first 3
      final unreadCount = _random.nextInt(10);

      // Generate messages first to get the last message snippet and time
      final messages = _generateMessages(conversationId, now);
      store.messages[conversationId] = messages;

      final lastMessage = messages.isNotEmpty ? messages.last : null;

      final conversation = Conversation(
        id: conversationId,
        title: title,
        lastMessageSnippet: lastMessage?.text,
        unreadCount: unreadCount,
        updatedAt: lastMessage?.createdAt ?? now.subtract(Duration(days: _random.nextInt(30))),
        pinned: isPinned,
      );

      store.conversations[conversationId] = conversation;
    }
  }

  List<Message> _generateMessages(String conversationId, DateTime baseTime) {
    final count = _random.nextInt(config.messagesPerConversation) + 1;
    final messages = <Message>[];
    var currentTime = baseTime.subtract(Duration(minutes: count * 10));

    for (int i = 0; i < count; i++) {
      final isIncoming = _random.nextBool();
      final text = _sentences[_random.nextInt(_sentences.length)];
      currentTime = currentTime.add(Duration(minutes: _random.nextInt(10) + 1));

      messages.add(
        Message(
          id: 'msg-$conversationId-$i',
          conversationId: conversationId,
          senderLabel: isIncoming ? 'Partner' : 'Me',
          text: text,
          createdAt: currentTime,
          direction: isIncoming ? MessageDirection.incoming : MessageDirection.outgoing,
          status: MessageStatus.sent,
          clientId: null,
        ),
      );
    }

    return messages;
  }
}
