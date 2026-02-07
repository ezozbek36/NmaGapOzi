import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'theme_config.g.dart';

@CopyWith()
@JsonSerializable()
/// Theme schema for color, spacing, and typography tokens.
class ThemeConfig extends Equatable {
  /// Active theme mode identifier, for example `light`, `dark`, or `system`.
  final String mode;

  /// Named color tokens used by the UI.
  final Map<String, String> colors;

  /// Named spacing tokens in logical pixels.
  final Map<String, double> spacing;

  /// Named font-size tokens in logical pixels.
  final Map<String, double> fontSizes;

  const ThemeConfig({required this.mode, this.colors = const {}, this.spacing = const {}, this.fontSizes = const {}});

  factory ThemeConfig.fromJson(Map<String, dynamic> json) => _$ThemeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ThemeConfigToJson(this);

  @override
  List<Object?> get props => [mode, colors, spacing, fontSizes];
}
