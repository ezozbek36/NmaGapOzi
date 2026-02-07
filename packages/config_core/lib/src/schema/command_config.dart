import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'command_config.g.dart';

@CopyWith()
@JsonSerializable()
/// Command metadata entry in the schema.
class CommandConfig extends Equatable {
  /// Stable command identifier.
  final String id;

  /// Human-readable command title.
  final String title;

  /// Optional icon token used by command UIs.
  final String? icon;

  /// Optional category label for grouping commands.
  final String? category;

  const CommandConfig({required this.id, required this.title, this.icon, this.category});

  factory CommandConfig.fromJson(Map<String, dynamic> json) => _$CommandConfigFromJson(json);

  Map<String, dynamic> toJson() => _$CommandConfigToJson(this);

  @override
  List<Object?> get props => [id, title, icon, category];
}
