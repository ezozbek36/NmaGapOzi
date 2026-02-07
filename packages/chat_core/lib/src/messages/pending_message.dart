import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:provider_api/provider_api.dart';

part 'pending_message.g.dart';

@CopyWith()
class PendingMessage extends Equatable {
  final String clientId;
  final String text;
  final MessageStatus status;
  final int retryCount;
  final String? error;

  const PendingMessage({required this.clientId, required this.text, required this.status, this.retryCount = 0, this.error});

  @override
  List<Object?> get props => [clientId, text, status, retryCount, error];
}
