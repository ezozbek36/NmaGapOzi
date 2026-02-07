import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'layout_config.dart';
import 'theme_config.dart';

part 'ui_config.g.dart';

@CopyWith()
@JsonSerializable(explicitToJson: true)
/// UI section of the application configuration schema.
class UiConfig extends Equatable {
  /// Theme tokens and mode settings.
  final ThemeConfig theme;

  /// Window layout visibility, sizes, and slot assignments.
  final LayoutConfig layout;

  const UiConfig({required this.theme, required this.layout});

  factory UiConfig.fromJson(Map<String, dynamic> json) => _$UiConfigFromJson(json);

  Map<String, dynamic> toJson() => _$UiConfigToJson(this);

  @override
  List<Object?> get props => [theme, layout];
}
