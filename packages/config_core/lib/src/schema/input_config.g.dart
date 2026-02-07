// GENERATED CODE - DO NOT MODIFY BY HAND

// coverage:ignore-file

part of 'input_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$KeybindingConfigCWProxy {
  KeybindingConfig key(String key);

  KeybindingConfig command(String command);

  KeybindingConfig when(String? when);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `KeybindingConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// KeybindingConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  KeybindingConfig call({String key, String command, String? when});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfKeybindingConfig.copyWith(...)` or call `instanceOfKeybindingConfig.copyWith.fieldName(value)` for a single field.
class _$KeybindingConfigCWProxyImpl implements _$KeybindingConfigCWProxy {
  const _$KeybindingConfigCWProxyImpl(this._value);

  final KeybindingConfig _value;

  @override
  KeybindingConfig key(String key) => call(key: key);

  @override
  KeybindingConfig command(String command) => call(command: command);

  @override
  KeybindingConfig when(String? when) => call(when: when);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `KeybindingConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// KeybindingConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  KeybindingConfig call({
    Object? key = const $CopyWithPlaceholder(),
    Object? command = const $CopyWithPlaceholder(),
    Object? when = const $CopyWithPlaceholder(),
  }) {
    return KeybindingConfig(
      key: key == const $CopyWithPlaceholder() || key == null
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      command: command == const $CopyWithPlaceholder() || command == null
          ? _value.command
          // ignore: cast_nullable_to_non_nullable
          : command as String,
      when: when == const $CopyWithPlaceholder()
          ? _value.when
          // ignore: cast_nullable_to_non_nullable
          : when as String?,
    );
  }
}

extension $KeybindingConfigCopyWith on KeybindingConfig {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfKeybindingConfig.copyWith(...)` or `instanceOfKeybindingConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$KeybindingConfigCWProxy get copyWith => _$KeybindingConfigCWProxyImpl(this);
}

abstract class _$InputConfigCWProxy {
  InputConfig keybindings(List<KeybindingConfig> keybindings);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `InputConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// InputConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  InputConfig call({List<KeybindingConfig> keybindings});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfInputConfig.copyWith(...)` or call `instanceOfInputConfig.copyWith.fieldName(value)` for a single field.
class _$InputConfigCWProxyImpl implements _$InputConfigCWProxy {
  const _$InputConfigCWProxyImpl(this._value);

  final InputConfig _value;

  @override
  InputConfig keybindings(List<KeybindingConfig> keybindings) =>
      call(keybindings: keybindings);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `InputConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// InputConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  InputConfig call({Object? keybindings = const $CopyWithPlaceholder()}) {
    return InputConfig(
      keybindings:
          keybindings == const $CopyWithPlaceholder() || keybindings == null
          ? _value.keybindings
          // ignore: cast_nullable_to_non_nullable
          : keybindings as List<KeybindingConfig>,
    );
  }
}

extension $InputConfigCopyWith on InputConfig {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfInputConfig.copyWith(...)` or `instanceOfInputConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InputConfigCWProxy get copyWith => _$InputConfigCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeybindingConfig _$KeybindingConfigFromJson(Map<String, dynamic> json) =>
    KeybindingConfig(
      key: json['key'] as String,
      command: json['command'] as String,
      when: json['when'] as String?,
    );

Map<String, dynamic> _$KeybindingConfigToJson(KeybindingConfig instance) =>
    <String, dynamic>{
      'key': instance.key,
      'command': instance.command,
      'when': instance.when,
    };

InputConfig _$InputConfigFromJson(Map<String, dynamic> json) => InputConfig(
  keybindings:
      (json['keybindings'] as List<dynamic>?)
          ?.map((e) => KeybindingConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$InputConfigToJson(InputConfig instance) =>
    <String, dynamic>{
      'keybindings': instance.keybindings.map((e) => e.toJson()).toList(),
    };
