import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'provider_config.g.dart';

@CopyWith()
@JsonSerializable()
/// Settings for the built-in mock provider.
class MockProviderSettings extends Equatable {
  /// Random seed for deterministic mock data.
  final int seed;

  /// Number of conversations to generate.
  final int conversationCount;

  /// Number of messages per generated conversation.
  final int messagesPerConversation;

  /// Minimum simulated latency in milliseconds.
  final int latencyMinMs;

  /// Maximum simulated latency in milliseconds.
  final int latencyMaxMs;

  /// Simulated failure ratio from `0.0` to `1.0`.
  final double failRate;

  const MockProviderSettings({
    this.seed = 42,
    this.conversationCount = 10,
    this.messagesPerConversation = 50,
    this.latencyMinMs = 50,
    this.latencyMaxMs = 300,
    this.failRate = 0.0,
  });

  factory MockProviderSettings.fromJson(Map<String, dynamic> json) => _$MockProviderSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$MockProviderSettingsToJson(this);

  @override
  List<Object?> get props => [seed, conversationCount, messagesPerConversation, latencyMinMs, latencyMaxMs, failRate];
}

@CopyWith()
@JsonSerializable(explicitToJson: true)
/// Provider section of the configuration schema.
class ProviderConfig extends Equatable {
  /// Active provider type identifier.
  final String type;

  /// Optional settings when `type` is `mock`.
  final MockProviderSettings? mock;

  const ProviderConfig({this.type = 'mock', this.mock});

  factory ProviderConfig.fromJson(Map<String, dynamic> json) => _$ProviderConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderConfigToJson(this);

  @override
  List<Object?> get props => [type, mock];
}
