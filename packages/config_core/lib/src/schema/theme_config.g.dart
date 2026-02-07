// GENERATED CODE - DO NOT MODIFY BY HAND

// coverage:ignore-file

part of 'theme_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThemeConfigCWProxy {
  ThemeConfig mode(String mode);

  ThemeConfig colors(Map<String, String> colors);

  ThemeConfig spacing(Map<String, double> spacing);

  ThemeConfig fontSizes(Map<String, double> fontSizes);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ThemeConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ThemeConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  ThemeConfig call({
    String mode,
    Map<String, String> colors,
    Map<String, double> spacing,
    Map<String, double> fontSizes,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfThemeConfig.copyWith(...)` or call `instanceOfThemeConfig.copyWith.fieldName(value)` for a single field.
class _$ThemeConfigCWProxyImpl implements _$ThemeConfigCWProxy {
  const _$ThemeConfigCWProxyImpl(this._value);

  final ThemeConfig _value;

  @override
  ThemeConfig mode(String mode) => call(mode: mode);

  @override
  ThemeConfig colors(Map<String, String> colors) => call(colors: colors);

  @override
  ThemeConfig spacing(Map<String, double> spacing) => call(spacing: spacing);

  @override
  ThemeConfig fontSizes(Map<String, double> fontSizes) =>
      call(fontSizes: fontSizes);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ThemeConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ThemeConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  ThemeConfig call({
    Object? mode = const $CopyWithPlaceholder(),
    Object? colors = const $CopyWithPlaceholder(),
    Object? spacing = const $CopyWithPlaceholder(),
    Object? fontSizes = const $CopyWithPlaceholder(),
  }) {
    return ThemeConfig(
      mode: mode == const $CopyWithPlaceholder() || mode == null
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as String,
      colors: colors == const $CopyWithPlaceholder() || colors == null
          ? _value.colors
          // ignore: cast_nullable_to_non_nullable
          : colors as Map<String, String>,
      spacing: spacing == const $CopyWithPlaceholder() || spacing == null
          ? _value.spacing
          // ignore: cast_nullable_to_non_nullable
          : spacing as Map<String, double>,
      fontSizes: fontSizes == const $CopyWithPlaceholder() || fontSizes == null
          ? _value.fontSizes
          // ignore: cast_nullable_to_non_nullable
          : fontSizes as Map<String, double>,
    );
  }
}

extension $ThemeConfigCopyWith on ThemeConfig {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfThemeConfig.copyWith(...)` or `instanceOfThemeConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThemeConfigCWProxy get copyWith => _$ThemeConfigCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeConfig _$ThemeConfigFromJson(Map<String, dynamic> json) => ThemeConfig(
  mode: json['mode'] as String,
  colors:
      (json['colors'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  spacing:
      (json['spacing'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  fontSizes:
      (json['fontSizes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
);

Map<String, dynamic> _$ThemeConfigToJson(ThemeConfig instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'colors': instance.colors,
      'spacing': instance.spacing,
      'fontSizes': instance.fontSizes,
    };
