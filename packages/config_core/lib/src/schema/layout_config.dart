import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'layout_config.g.dart';

@CopyWith()
@JsonSerializable()
/// Layout schema for panel visibility, sizes, and slot placement.
class LayoutConfig extends Equatable {
  /// Whether the left sidebar is shown.
  final bool showLeftSidebar;

  /// Whether the right sidebar is shown.
  final bool showRightSidebar;

  /// Whether the bottom panel is shown.
  final bool showBottomPanel;

  /// Width of the left sidebar in logical pixels.
  final double leftSidebarWidth;

  /// Width of the right sidebar in logical pixels.
  final double rightSidebarWidth;

  /// Height of the bottom panel in logical pixels.
  final double bottomPanelHeight;

  /// Slot-to-widget mapping used for dynamic layout composition.
  final Map<String, dynamic> slots;

  const LayoutConfig({
    this.showLeftSidebar = true,
    this.showRightSidebar = true,
    this.showBottomPanel = true,
    this.leftSidebarWidth = 280.0,
    this.rightSidebarWidth = 280.0,
    this.bottomPanelHeight = 200.0,
    this.slots = const {},
  });

  factory LayoutConfig.fromJson(Map<String, dynamic> json) => _$LayoutConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LayoutConfigToJson(this);

  @override
  List<Object?> get props => [
    showLeftSidebar,
    showRightSidebar,
    showBottomPanel,
    leftSidebarWidth,
    rightSidebarWidth,
    bottomPanelHeight,
    slots,
  ];
}
