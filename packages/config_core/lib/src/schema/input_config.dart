import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'input_config.g.dart';

@CopyWith()
@JsonSerializable()
/// Single keybinding rule in the input schema.
class KeybindingConfig extends Equatable {
  /// Keyboard gesture string, for example `ctrl+k`.
  final String key;

  /// Command id to invoke when the keybinding matches.
  final String command;

  /// Optional condition expression controlling when binding is active.
  final String? when;

  const KeybindingConfig({required this.key, required this.command, this.when});

  factory KeybindingConfig.fromJson(Map<String, dynamic> json) => _$KeybindingConfigFromJson(json);

  Map<String, dynamic> toJson() => _$KeybindingConfigToJson(this);

  @override
  List<Object?> get props => [key, command, when];
}

@JsonSerializable(explicitToJson: true)
@CopyWith()
/// Input section of the configuration schema.
class InputConfig extends Equatable {
  /// Ordered list of keybinding rules.
  final List<KeybindingConfig> keybindings;

  const InputConfig({this.keybindings = const []});

  factory InputConfig.fromJson(Map<String, dynamic> json) => _$InputConfigFromJson(json);

  Map<String, dynamic> toJson() => _$InputConfigToJson(this);

  @override
  List<Object?> get props => [keybindings];
}
