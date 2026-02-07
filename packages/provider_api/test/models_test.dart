import 'package:provider_api/provider_api.dart';
import 'package:test/test.dart';

void main() {
  group('Models', () {
    test('ProviderSession serialization', () {
      final session = ProviderSession(userId: 'user123', displayName: 'Test User', expiresAt: DateTime(2023, 1, 1));

      final json = session.toJson();
      expect(json['userId'], 'user123');
      expect(json['displayName'], 'Test User');

      final restored = ProviderSession.fromJson(json);
      expect(restored, session);
    });

    test('Conversation serialization', () {
      final conversation = Conversation(id: 'conv123', title: 'Chat', unreadCount: 2, updatedAt: DateTime(2023, 1, 1), pinned: false);

      final json = conversation.toJson();
      expect(json['id'], 'conv123');
      expect(json['unreadCount'], 2);

      final restored = Conversation.fromJson(json);
      expect(restored, conversation);
    });

    test('Message serialization', () {
      final message = Message(
        id: 'msg123',
        conversationId: 'conv123',
        senderLabel: 'Alice',
        text: 'Hello',
        createdAt: DateTime(2023, 1, 1),
        direction: MessageDirection.incoming,
        status: MessageStatus.sent,
      );

      final json = message.toJson();
      expect(json['text'], 'Hello');
      expect(json['direction'], 'incoming');

      final restored = Message.fromJson(json);
      expect(restored, message);
    });
  });

  group('Events', () {
    test('NewMessageEvent instantiation', () {
      final message = Message(
        id: 'msg123',
        conversationId: 'conv123',
        senderLabel: 'Alice',
        text: 'Hello',
        createdAt: DateTime.now(),
        direction: MessageDirection.incoming,
        status: MessageStatus.sent,
      );

      final event = NewMessageEvent(conversationId: 'conv123', message: message);

      expect(event, isA<ProviderEvent>());
      // Accessing field via pattern matching or cast
      if (event case NewMessageEvent e) {
        expect(e.conversationId, 'conv123');
        expect(e.message, message);
      } else {
        fail('Event should be NewMessageEvent');
      }
    });
  });
}
