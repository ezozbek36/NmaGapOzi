import 'package:provider_api/provider_api.dart';

class SendMessageUseCase {
  final IChatProvider _provider;

  SendMessageUseCase(this._provider);

  Future<void> send({required String conversationId, required String text, required String clientId}) async {
    final result = await _provider.sendMessage(conversationId: conversationId, clientMessageId: clientId, text: text);

    if (!result.accepted) {
      throw Exception(result.error ?? 'Message sending failed');
    }
  }

  Future<void> retry(String clientId, String conversationId, String text) async {
    final result = await _provider.sendMessage(conversationId: conversationId, clientMessageId: clientId, text: text);

    if (!result.accepted) {
      throw Exception(result.error ?? 'Message retry failed');
    }
  }

  void cancel(String clientId) {}
}
