import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_result.g.dart';

@CopyWith()
@JsonSerializable()
class SendResult extends Equatable {
  final String clientMessageId;
  final bool accepted;
  final String? error;

  const SendResult({required this.clientMessageId, required this.accepted, this.error});

  factory SendResult.fromJson(Map<String, dynamic> json) => _$SendResultFromJson(json);

  Map<String, dynamic> toJson() => _$SendResultToJson(this);

  @override
  List<Object?> get props => [clientMessageId, accepted, error];
}
