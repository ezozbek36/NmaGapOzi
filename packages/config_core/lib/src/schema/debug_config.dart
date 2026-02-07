import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'debug_config.g.dart';

@CopyWith()
@JsonSerializable()
/// Debug section of the configuration schema.
class DebugConfig extends Equatable {
  /// Whether the UI inspector panel is visible.
  final bool showInspector;

  /// Whether event logs are shown in the UI.
  final bool showEventLog;

  /// Whether the app intentionally simulates provider errors.
  final bool simulateErrors;

  /// Log verbosity level.
  final int logLevel;

  const DebugConfig({this.showInspector = false, this.showEventLog = false, this.simulateErrors = false, this.logLevel = 1});

  factory DebugConfig.fromJson(Map<String, dynamic> json) => _$DebugConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DebugConfigToJson(this);

  @override
  List<Object?> get props => [showInspector, showEventLog, simulateErrors, logLevel];
}
