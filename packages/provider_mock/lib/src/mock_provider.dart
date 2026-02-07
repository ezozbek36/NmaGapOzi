import 'dart:async';
import 'dart:math';

import 'package:provider_api/provider_api.dart';

import 'data_generator.dart';
import 'mock_config.dart';
import 'mock_store.dart';
import 'simulation/events.dart';
import 'simulation/failure.dart';
import 'simulation/latency.dart';

class MockChatProvider implements IChatProvider {
  final MockProviderConfig config;
  final MockStore _store = MockStore();
  late final MockDataGenerator _generator;
  late final LatencySimulator _latency;
  late final FailureSimulator _failure;
  final EventSimulator _eventSimulator = EventSimulator();

  MockChatProvider({this.config = const MockProviderConfig()}) {
    _generator = MockDataGenerator(config, _store);
    _latency = LatencySimulator(config);
    _failure = FailureSimulator(config);
    _generator.generate();
  }

  @override
  ProviderSession? get currentSession => _store.session;

  @override
  Stream<ProviderEvent> get events => _eventSimulator.events;

  @override
  Future<ProviderSession?> restoreSession() async {
    await _latency.simulate();
    _failure.check();
    return _store.session;
  }

  @override
  Future<ProviderSession> login(LoginParams params) async {
    await _latency.simulate();
    _failure.check();

    final session = ProviderSession(
      userId: 'user-${config.seed}',
      displayName: params.username,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
    _store.session = session;
    return session;
  }

  @override
  Future<void> logout() async {
    await _latency.simulate();
    _failure.check();
    _store.session = null;
    _eventSimulator.emit(SessionExpiredEvent());
  }

  @override
  Future<ConversationPage> listConversations({String? cursor, int limit = 50, String? query}) async {
    await _latency.simulate();
    _failure.check();

    var allConvs = _store.conversations.values.toList();

    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      allConvs = allConvs.where((c) => c.title.toLowerCase().contains(lowerQuery)).toList();
    }

    allConvs.sort((a, b) {
      if (a.pinned != b.pinned) {
        return a.pinned ? -1 : 1;
      }
      return b.updatedAt.compareTo(a.updatedAt);
    });

    int offset = 0;
    if (cursor != null) {
      offset = int.tryParse(cursor) ?? 0;
    }

    final hasMore = offset + limit < allConvs.length;
    final items = allConvs.skip(offset).take(limit).toList();
    final nextCursor = hasMore ? (offset + limit).toString() : null;

    return ConversationPage(items: items, nextCursor: nextCursor, hasMore: hasMore);
  }

  @override
  Future<MessagePage> listMessages({required String conversationId, String? beforeMessageId, int limit = 50}) async {
    await _latency.simulate();
    _failure.check();

    final allMessages = _store.messages[conversationId] ?? [];

    // Sort by createdAt asc
    allMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    List<Message> resultItems;
    bool hasMore;

    if (beforeMessageId == null) {
      if (allMessages.length <= limit) {
        resultItems = allMessages;
        hasMore = false;
      } else {
        resultItems = allMessages.sublist(allMessages.length - limit);
        hasMore = true;
      }
    } else {
      final index = allMessages.indexWhere((m) => m.id == beforeMessageId);
      if (index == -1) {
        resultItems = [];
        hasMore = false;
      } else {
        final startIndex = max(0, index - limit);
        resultItems = allMessages.sublist(startIndex, index);
        hasMore = startIndex > 0;
      }
    }

    return MessagePage(items: resultItems, hasMore: hasMore);
  }

  @override
  Future<SendResult> sendMessage({required String conversationId, required String clientMessageId, required String text}) async {
    if (_store.session == null) {
      return SendResult(clientMessageId: clientMessageId, accepted: false, error: 'Not authenticated');
    }

    _processSendMessage(conversationId, clientMessageId, text);

    return SendResult(clientMessageId: clientMessageId, accepted: true);
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    await _latency.simulate();
    _failure.check();

    final conv = _store.conversations[conversationId];
    if (conv != null && conv.unreadCount > 0) {
      final updatedConv = conv.copyWith(unreadCount: 0);
      _store.conversations[conversationId] = updatedConv;
      _eventSimulator.emit(ConversationUpdatedEvent(conversation: updatedConv));
    }
  }

  Future<void> _processSendMessage(String conversationId, String clientMessageId, String text) async {
    try {
      await _latency.simulate();
      _failure.check();

      final serverMessageId = 'msg-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000)}';
      final now = DateTime.now();

      final newMessage = Message(
        id: serverMessageId,
        conversationId: conversationId,
        senderLabel: 'Me',
        text: text,
        createdAt: now,
        direction: MessageDirection.outgoing,
        status: MessageStatus.sent,
        clientId: clientMessageId,
      );

      if (!_store.messages.containsKey(conversationId)) {
        _store.messages[conversationId] = [];
      }
      _store.messages[conversationId]!.add(newMessage);

      final conv = _store.conversations[conversationId];
      if (conv != null) {
        final updatedConv = conv.copyWith(lastMessageSnippet: text, updatedAt: now);
        _store.conversations[conversationId] = updatedConv;
        _eventSimulator.emit(ConversationUpdatedEvent(conversation: updatedConv));
      }

      _eventSimulator.emit(MessageAckEvent(clientMessageId: clientMessageId, serverMessageId: serverMessageId, timestamp: now));

      _eventSimulator.emit(NewMessageEvent(conversationId: conversationId, message: newMessage));
    } catch (e) {
      _eventSimulator.emit(MessageFailedEvent(clientMessageId: clientMessageId, errorCode: e.toString()));
    }
  }
}
