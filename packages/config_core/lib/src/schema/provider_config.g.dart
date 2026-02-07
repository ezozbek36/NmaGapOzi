// GENERATED CODE - DO NOT MODIFY BY HAND

// coverage:ignore-file

part of 'provider_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MockProviderSettingsCWProxy {
  MockProviderSettings seed(int seed);

  MockProviderSettings conversationCount(int conversationCount);

  MockProviderSettings messagesPerConversation(int messagesPerConversation);

  MockProviderSettings latencyMinMs(int latencyMinMs);

  MockProviderSettings latencyMaxMs(int latencyMaxMs);

  MockProviderSettings failRate(double failRate);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MockProviderSettings(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MockProviderSettings(...).copyWith(id: 12, name: "My name")
  /// ```
  MockProviderSettings call({
    int seed,
    int conversationCount,
    int messagesPerConversation,
    int latencyMinMs,
    int latencyMaxMs,
    double failRate,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMockProviderSettings.copyWith(...)` or call `instanceOfMockProviderSettings.copyWith.fieldName(value)` for a single field.
class _$MockProviderSettingsCWProxyImpl
    implements _$MockProviderSettingsCWProxy {
  const _$MockProviderSettingsCWProxyImpl(this._value);

  final MockProviderSettings _value;

  @override
  MockProviderSettings seed(int seed) => call(seed: seed);

  @override
  MockProviderSettings conversationCount(int conversationCount) =>
      call(conversationCount: conversationCount);

  @override
  MockProviderSettings messagesPerConversation(int messagesPerConversation) =>
      call(messagesPerConversation: messagesPerConversation);

  @override
  MockProviderSettings latencyMinMs(int latencyMinMs) =>
      call(latencyMinMs: latencyMinMs);

  @override
  MockProviderSettings latencyMaxMs(int latencyMaxMs) =>
      call(latencyMaxMs: latencyMaxMs);

  @override
  MockProviderSettings failRate(double failRate) => call(failRate: failRate);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `MockProviderSettings(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// MockProviderSettings(...).copyWith(id: 12, name: "My name")
  /// ```
  MockProviderSettings call({
    Object? seed = const $CopyWithPlaceholder(),
    Object? conversationCount = const $CopyWithPlaceholder(),
    Object? messagesPerConversation = const $CopyWithPlaceholder(),
    Object? latencyMinMs = const $CopyWithPlaceholder(),
    Object? latencyMaxMs = const $CopyWithPlaceholder(),
    Object? failRate = const $CopyWithPlaceholder(),
  }) {
    return MockProviderSettings(
      seed: seed == const $CopyWithPlaceholder() || seed == null
          ? _value.seed
          // ignore: cast_nullable_to_non_nullable
          : seed as int,
      conversationCount:
          conversationCount == const $CopyWithPlaceholder() ||
              conversationCount == null
          ? _value.conversationCount
          // ignore: cast_nullable_to_non_nullable
          : conversationCount as int,
      messagesPerConversation:
          messagesPerConversation == const $CopyWithPlaceholder() ||
              messagesPerConversation == null
          ? _value.messagesPerConversation
          // ignore: cast_nullable_to_non_nullable
          : messagesPerConversation as int,
      latencyMinMs:
          latencyMinMs == const $CopyWithPlaceholder() || latencyMinMs == null
          ? _value.latencyMinMs
          // ignore: cast_nullable_to_non_nullable
          : latencyMinMs as int,
      latencyMaxMs:
          latencyMaxMs == const $CopyWithPlaceholder() || latencyMaxMs == null
          ? _value.latencyMaxMs
          // ignore: cast_nullable_to_non_nullable
          : latencyMaxMs as int,
      failRate: failRate == const $CopyWithPlaceholder() || failRate == null
          ? _value.failRate
          // ignore: cast_nullable_to_non_nullable
          : failRate as double,
    );
  }
}

extension $MockProviderSettingsCopyWith on MockProviderSettings {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMockProviderSettings.copyWith(...)` or `instanceOfMockProviderSettings.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MockProviderSettingsCWProxy get copyWith =>
      _$MockProviderSettingsCWProxyImpl(this);
}

abstract class _$ProviderConfigCWProxy {
  ProviderConfig type(String type);

  ProviderConfig mock(MockProviderSettings? mock);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ProviderConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProviderConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  ProviderConfig call({String type, MockProviderSettings? mock});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfProviderConfig.copyWith(...)` or call `instanceOfProviderConfig.copyWith.fieldName(value)` for a single field.
class _$ProviderConfigCWProxyImpl implements _$ProviderConfigCWProxy {
  const _$ProviderConfigCWProxyImpl(this._value);

  final ProviderConfig _value;

  @override
  ProviderConfig type(String type) => call(type: type);

  @override
  ProviderConfig mock(MockProviderSettings? mock) => call(mock: mock);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ProviderConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProviderConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  ProviderConfig call({
    Object? type = const $CopyWithPlaceholder(),
    Object? mock = const $CopyWithPlaceholder(),
  }) {
    return ProviderConfig(
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      mock: mock == const $CopyWithPlaceholder()
          ? _value.mock
          // ignore: cast_nullable_to_non_nullable
          : mock as MockProviderSettings?,
    );
  }
}

extension $ProviderConfigCopyWith on ProviderConfig {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfProviderConfig.copyWith(...)` or `instanceOfProviderConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProviderConfigCWProxy get copyWith => _$ProviderConfigCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MockProviderSettings _$MockProviderSettingsFromJson(
  Map<String, dynamic> json,
) => MockProviderSettings(
  seed: (json['seed'] as num?)?.toInt() ?? 42,
  conversationCount: (json['conversationCount'] as num?)?.toInt() ?? 10,
  messagesPerConversation:
      (json['messagesPerConversation'] as num?)?.toInt() ?? 50,
  latencyMinMs: (json['latencyMinMs'] as num?)?.toInt() ?? 50,
  latencyMaxMs: (json['latencyMaxMs'] as num?)?.toInt() ?? 300,
  failRate: (json['failRate'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$MockProviderSettingsToJson(
  MockProviderSettings instance,
) => <String, dynamic>{
  'seed': instance.seed,
  'conversationCount': instance.conversationCount,
  'messagesPerConversation': instance.messagesPerConversation,
  'latencyMinMs': instance.latencyMinMs,
  'latencyMaxMs': instance.latencyMaxMs,
  'failRate': instance.failRate,
};

ProviderConfig _$ProviderConfigFromJson(Map<String, dynamic> json) =>
    ProviderConfig(
      type: json['type'] as String? ?? 'mock',
      mock: json['mock'] == null
          ? null
          : MockProviderSettings.fromJson(json['mock'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProviderConfigToJson(ProviderConfig instance) =>
    <String, dynamic>{'type': instance.type, 'mock': instance.mock?.toJson()};
