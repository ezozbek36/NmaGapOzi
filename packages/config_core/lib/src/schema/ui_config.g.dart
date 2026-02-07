// GENERATED CODE - DO NOT MODIFY BY HAND

// coverage:ignore-file

part of 'ui_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UiConfigCWProxy {
  UiConfig theme(ThemeConfig theme);

  UiConfig layout(LayoutConfig layout);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UiConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UiConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  UiConfig call({ThemeConfig theme, LayoutConfig layout});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUiConfig.copyWith(...)` or call `instanceOfUiConfig.copyWith.fieldName(value)` for a single field.
class _$UiConfigCWProxyImpl implements _$UiConfigCWProxy {
  const _$UiConfigCWProxyImpl(this._value);

  final UiConfig _value;

  @override
  UiConfig theme(ThemeConfig theme) => call(theme: theme);

  @override
  UiConfig layout(LayoutConfig layout) => call(layout: layout);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UiConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UiConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  UiConfig call({
    Object? theme = const $CopyWithPlaceholder(),
    Object? layout = const $CopyWithPlaceholder(),
  }) {
    return UiConfig(
      theme: theme == const $CopyWithPlaceholder() || theme == null
          ? _value.theme
          // ignore: cast_nullable_to_non_nullable
          : theme as ThemeConfig,
      layout: layout == const $CopyWithPlaceholder() || layout == null
          ? _value.layout
          // ignore: cast_nullable_to_non_nullable
          : layout as LayoutConfig,
    );
  }
}

extension $UiConfigCopyWith on UiConfig {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUiConfig.copyWith(...)` or `instanceOfUiConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UiConfigCWProxy get copyWith => _$UiConfigCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UiConfig _$UiConfigFromJson(Map<String, dynamic> json) => UiConfig(
  theme: ThemeConfig.fromJson(json['theme'] as Map<String, dynamic>),
  layout: LayoutConfig.fromJson(json['layout'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UiConfigToJson(UiConfig instance) => <String, dynamic>{
  'theme': instance.theme.toJson(),
  'layout': instance.layout.toJson(),
};
