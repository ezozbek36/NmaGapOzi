// GENERATED CODE - DO NOT MODIFY BY HAND

// coverage:ignore-file

part of 'layout_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LayoutConfigCWProxy {
  LayoutConfig showLeftSidebar(bool showLeftSidebar);

  LayoutConfig showRightSidebar(bool showRightSidebar);

  LayoutConfig showBottomPanel(bool showBottomPanel);

  LayoutConfig leftSidebarWidth(double leftSidebarWidth);

  LayoutConfig rightSidebarWidth(double rightSidebarWidth);

  LayoutConfig bottomPanelHeight(double bottomPanelHeight);

  LayoutConfig slots(Map<String, dynamic> slots);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LayoutConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LayoutConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  LayoutConfig call({
    bool showLeftSidebar,
    bool showRightSidebar,
    bool showBottomPanel,
    double leftSidebarWidth,
    double rightSidebarWidth,
    double bottomPanelHeight,
    Map<String, dynamic> slots,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLayoutConfig.copyWith(...)` or call `instanceOfLayoutConfig.copyWith.fieldName(value)` for a single field.
class _$LayoutConfigCWProxyImpl implements _$LayoutConfigCWProxy {
  const _$LayoutConfigCWProxyImpl(this._value);

  final LayoutConfig _value;

  @override
  LayoutConfig showLeftSidebar(bool showLeftSidebar) =>
      call(showLeftSidebar: showLeftSidebar);

  @override
  LayoutConfig showRightSidebar(bool showRightSidebar) =>
      call(showRightSidebar: showRightSidebar);

  @override
  LayoutConfig showBottomPanel(bool showBottomPanel) =>
      call(showBottomPanel: showBottomPanel);

  @override
  LayoutConfig leftSidebarWidth(double leftSidebarWidth) =>
      call(leftSidebarWidth: leftSidebarWidth);

  @override
  LayoutConfig rightSidebarWidth(double rightSidebarWidth) =>
      call(rightSidebarWidth: rightSidebarWidth);

  @override
  LayoutConfig bottomPanelHeight(double bottomPanelHeight) =>
      call(bottomPanelHeight: bottomPanelHeight);

  @override
  LayoutConfig slots(Map<String, dynamic> slots) => call(slots: slots);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LayoutConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LayoutConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  LayoutConfig call({
    Object? showLeftSidebar = const $CopyWithPlaceholder(),
    Object? showRightSidebar = const $CopyWithPlaceholder(),
    Object? showBottomPanel = const $CopyWithPlaceholder(),
    Object? leftSidebarWidth = const $CopyWithPlaceholder(),
    Object? rightSidebarWidth = const $CopyWithPlaceholder(),
    Object? bottomPanelHeight = const $CopyWithPlaceholder(),
    Object? slots = const $CopyWithPlaceholder(),
  }) {
    return LayoutConfig(
      showLeftSidebar:
          showLeftSidebar == const $CopyWithPlaceholder() ||
              showLeftSidebar == null
          ? _value.showLeftSidebar
          // ignore: cast_nullable_to_non_nullable
          : showLeftSidebar as bool,
      showRightSidebar:
          showRightSidebar == const $CopyWithPlaceholder() ||
              showRightSidebar == null
          ? _value.showRightSidebar
          // ignore: cast_nullable_to_non_nullable
          : showRightSidebar as bool,
      showBottomPanel:
          showBottomPanel == const $CopyWithPlaceholder() ||
              showBottomPanel == null
          ? _value.showBottomPanel
          // ignore: cast_nullable_to_non_nullable
          : showBottomPanel as bool,
      leftSidebarWidth:
          leftSidebarWidth == const $CopyWithPlaceholder() ||
              leftSidebarWidth == null
          ? _value.leftSidebarWidth
          // ignore: cast_nullable_to_non_nullable
          : leftSidebarWidth as double,
      rightSidebarWidth:
          rightSidebarWidth == const $CopyWithPlaceholder() ||
              rightSidebarWidth == null
          ? _value.rightSidebarWidth
          // ignore: cast_nullable_to_non_nullable
          : rightSidebarWidth as double,
      bottomPanelHeight:
          bottomPanelHeight == const $CopyWithPlaceholder() ||
              bottomPanelHeight == null
          ? _value.bottomPanelHeight
          // ignore: cast_nullable_to_non_nullable
          : bottomPanelHeight as double,
      slots: slots == const $CopyWithPlaceholder() || slots == null
          ? _value.slots
          // ignore: cast_nullable_to_non_nullable
          : slots as Map<String, dynamic>,
    );
  }
}

extension $LayoutConfigCopyWith on LayoutConfig {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLayoutConfig.copyWith(...)` or `instanceOfLayoutConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LayoutConfigCWProxy get copyWith => _$LayoutConfigCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LayoutConfig _$LayoutConfigFromJson(Map<String, dynamic> json) => LayoutConfig(
  showLeftSidebar: json['showLeftSidebar'] as bool? ?? true,
  showRightSidebar: json['showRightSidebar'] as bool? ?? true,
  showBottomPanel: json['showBottomPanel'] as bool? ?? true,
  leftSidebarWidth: (json['leftSidebarWidth'] as num?)?.toDouble() ?? 280.0,
  rightSidebarWidth: (json['rightSidebarWidth'] as num?)?.toDouble() ?? 280.0,
  bottomPanelHeight: (json['bottomPanelHeight'] as num?)?.toDouble() ?? 200.0,
  slots: json['slots'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$LayoutConfigToJson(LayoutConfig instance) =>
    <String, dynamic>{
      'showLeftSidebar': instance.showLeftSidebar,
      'showRightSidebar': instance.showRightSidebar,
      'showBottomPanel': instance.showBottomPanel,
      'leftSidebarWidth': instance.leftSidebarWidth,
      'rightSidebarWidth': instance.rightSidebarWidth,
      'bottomPanelHeight': instance.bottomPanelHeight,
      'slots': instance.slots,
    };
