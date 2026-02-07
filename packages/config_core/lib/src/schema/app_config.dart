import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'command_config.dart';
import 'debug_config.dart';
import 'input_config.dart';
import 'provider_config.dart';
import 'ui_config.dart';

part 'app_config.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true, createJsonSchema: true)
/// Root configuration schema for the application.
class AppConfig extends Equatable {
  /// Version of the config schema used for migration.
  final int configVersion;

  /// Visual settings such as theme and layout.
  final UiConfig ui;

  /// Input settings such as keyboard bindings.
  final InputConfig input;

  /// User-defined command metadata.
  final List<CommandConfig> commands;

  /// Runtime provider selection and provider-specific settings.
  final ProviderConfig provider;

  /// Debug and diagnostics behavior toggles.
  final DebugConfig debug;

  const AppConfig({
    required this.configVersion,
    required this.ui,
    required this.input,
    this.commands = const [],
    required this.provider,
    required this.debug,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  @override
  List<Object?> get props => [configVersion, ui, input, commands, provider, debug];
}

/// Generated JSON schema definition for [AppConfig].
Map<String, dynamic> get appConfigJsonSchema => _$AppConfigJsonSchema;
