// GENERATED CODE - DO NOT MODIFY BY HAND

// coverage:ignore-file

part of 'command_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CommandConfigCWProxy {
  CommandConfig id(String id);

  CommandConfig title(String title);

  CommandConfig icon(String? icon);

  CommandConfig category(String? category);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CommandConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CommandConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  CommandConfig call({String id, String title, String? icon, String? category});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCommandConfig.copyWith(...)` or call `instanceOfCommandConfig.copyWith.fieldName(value)` for a single field.
class _$CommandConfigCWProxyImpl implements _$CommandConfigCWProxy {
  const _$CommandConfigCWProxyImpl(this._value);

  final CommandConfig _value;

  @override
  CommandConfig id(String id) => call(id: id);

  @override
  CommandConfig title(String title) => call(title: title);

  @override
  CommandConfig icon(String? icon) => call(icon: icon);

  @override
  CommandConfig category(String? category) => call(category: category);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CommandConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CommandConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  CommandConfig call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? icon = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
  }) {
    return CommandConfig(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      title: title == const $CopyWithPlaceholder() || title == null
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      icon: icon == const $CopyWithPlaceholder()
          ? _value.icon
          // ignore: cast_nullable_to_non_nullable
          : icon as String?,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as String?,
    );
  }
}

extension $CommandConfigCopyWith on CommandConfig {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCommandConfig.copyWith(...)` or `instanceOfCommandConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CommandConfigCWProxy get copyWith => _$CommandConfigCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommandConfig _$CommandConfigFromJson(Map<String, dynamic> json) =>
    CommandConfig(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$CommandConfigToJson(CommandConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.icon,
      'category': instance.category,
    };
