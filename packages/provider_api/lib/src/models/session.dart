import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@CopyWith()
@JsonSerializable()
class ProviderSession extends Equatable {
  final String userId;
  final String displayName;
  final DateTime expiresAt;

  const ProviderSession({required this.userId, required this.displayName, required this.expiresAt});

  factory ProviderSession.fromJson(Map<String, dynamic> json) => _$ProviderSessionFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderSessionToJson(this);

  @override
  List<Object?> get props => [userId, displayName, expiresAt];
}

@CopyWith()
@JsonSerializable()
class LoginParams extends Equatable {
  final String username;
  final String code;

  const LoginParams({required this.username, required this.code});

  factory LoginParams.fromJson(Map<String, dynamic> json) => _$LoginParamsFromJson(json);

  Map<String, dynamic> toJson() => _$LoginParamsToJson(this);

  @override
  List<Object?> get props => [username, code];
}
