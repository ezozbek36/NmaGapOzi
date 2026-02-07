// GENERATED CODE - DO NOT MODIFY BY HAND

// coverage:ignore-file

part of 'debug_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DebugConfigCWProxy {
  DebugConfig showInspector(bool showInspector);

  DebugConfig showEventLog(bool showEventLog);

  DebugConfig simulateErrors(bool simulateErrors);

  DebugConfig logLevel(int logLevel);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `DebugConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DebugConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  DebugConfig call({
    bool showInspector,
    bool showEventLog,
    bool simulateErrors,
    int logLevel,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfDebugConfig.copyWith(...)` or call `instanceOfDebugConfig.copyWith.fieldName(value)` for a single field.
class _$DebugConfigCWProxyImpl implements _$DebugConfigCWProxy {
  const _$DebugConfigCWProxyImpl(this._value);

  final DebugConfig _value;

  @override
  DebugConfig showInspector(bool showInspector) =>
      call(showInspector: showInspector);

  @override
  DebugConfig showEventLog(bool showEventLog) =>
      call(showEventLog: showEventLog);

  @override
  DebugConfig simulateErrors(bool simulateErrors) =>
      call(simulateErrors: simulateErrors);

  @override
  DebugConfig logLevel(int logLevel) => call(logLevel: logLevel);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `DebugConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// DebugConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  DebugConfig call({
    Object? showInspector = const $CopyWithPlaceholder(),
    Object? showEventLog = const $CopyWithPlaceholder(),
    Object? simulateErrors = const $CopyWithPlaceholder(),
    Object? logLevel = const $CopyWithPlaceholder(),
  }) {
    return DebugConfig(
      showInspector:
          showInspector == const $CopyWithPlaceholder() || showInspector == null
          ? _value.showInspector
          // ignore: cast_nullable_to_non_nullable
          : showInspector as bool,
      showEventLog:
          showEventLog == const $CopyWithPlaceholder() || showEventLog == null
          ? _value.showEventLog
          // ignore: cast_nullable_to_non_nullable
          : showEventLog as bool,
      simulateErrors:
          simulateErrors == const $CopyWithPlaceholder() ||
              simulateErrors == null
          ? _value.simulateErrors
          // ignore: cast_nullable_to_non_nullable
          : simulateErrors as bool,
      logLevel: logLevel == const $CopyWithPlaceholder() || logLevel == null
          ? _value.logLevel
          // ignore: cast_nullable_to_non_nullable
          : logLevel as int,
    );
  }
}

extension $DebugConfigCopyWith on DebugConfig {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfDebugConfig.copyWith(...)` or `instanceOfDebugConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DebugConfigCWProxy get copyWith => _$DebugConfigCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebugConfig _$DebugConfigFromJson(Map<String, dynamic> json) => DebugConfig(
  showInspector: json['showInspector'] as bool? ?? false,
  showEventLog: json['showEventLog'] as bool? ?? false,
  simulateErrors: json['simulateErrors'] as bool? ?? false,
  logLevel: (json['logLevel'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$DebugConfigToJson(DebugConfig instance) =>
    <String, dynamic>{
      'showInspector': instance.showInspector,
      'showEventLog': instance.showEventLog,
      'simulateErrors': instance.simulateErrors,
      'logLevel': instance.logLevel,
    };
