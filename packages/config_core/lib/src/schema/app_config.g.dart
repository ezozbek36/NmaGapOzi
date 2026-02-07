// GENERATED CODE - DO NOT MODIFY BY HAND

// coverage:ignore-file

part of 'app_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppConfigCWProxy {
  AppConfig configVersion(int configVersion);

  AppConfig ui(UiConfig ui);

  AppConfig input(InputConfig input);

  AppConfig commands(List<CommandConfig> commands);

  AppConfig provider(ProviderConfig provider);

  AppConfig debug(DebugConfig debug);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AppConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AppConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  AppConfig call({
    int configVersion,
    UiConfig ui,
    InputConfig input,
    List<CommandConfig> commands,
    ProviderConfig provider,
    DebugConfig debug,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAppConfig.copyWith(...)` or call `instanceOfAppConfig.copyWith.fieldName(value)` for a single field.
class _$AppConfigCWProxyImpl implements _$AppConfigCWProxy {
  const _$AppConfigCWProxyImpl(this._value);

  final AppConfig _value;

  @override
  AppConfig configVersion(int configVersion) =>
      call(configVersion: configVersion);

  @override
  AppConfig ui(UiConfig ui) => call(ui: ui);

  @override
  AppConfig input(InputConfig input) => call(input: input);

  @override
  AppConfig commands(List<CommandConfig> commands) => call(commands: commands);

  @override
  AppConfig provider(ProviderConfig provider) => call(provider: provider);

  @override
  AppConfig debug(DebugConfig debug) => call(debug: debug);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AppConfig(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AppConfig(...).copyWith(id: 12, name: "My name")
  /// ```
  AppConfig call({
    Object? configVersion = const $CopyWithPlaceholder(),
    Object? ui = const $CopyWithPlaceholder(),
    Object? input = const $CopyWithPlaceholder(),
    Object? commands = const $CopyWithPlaceholder(),
    Object? provider = const $CopyWithPlaceholder(),
    Object? debug = const $CopyWithPlaceholder(),
  }) {
    return AppConfig(
      configVersion:
          configVersion == const $CopyWithPlaceholder() || configVersion == null
          ? _value.configVersion
          // ignore: cast_nullable_to_non_nullable
          : configVersion as int,
      ui: ui == const $CopyWithPlaceholder() || ui == null
          ? _value.ui
          // ignore: cast_nullable_to_non_nullable
          : ui as UiConfig,
      input: input == const $CopyWithPlaceholder() || input == null
          ? _value.input
          // ignore: cast_nullable_to_non_nullable
          : input as InputConfig,
      commands: commands == const $CopyWithPlaceholder() || commands == null
          ? _value.commands
          // ignore: cast_nullable_to_non_nullable
          : commands as List<CommandConfig>,
      provider: provider == const $CopyWithPlaceholder() || provider == null
          ? _value.provider
          // ignore: cast_nullable_to_non_nullable
          : provider as ProviderConfig,
      debug: debug == const $CopyWithPlaceholder() || debug == null
          ? _value.debug
          // ignore: cast_nullable_to_non_nullable
          : debug as DebugConfig,
    );
  }
}

extension $AppConfigCopyWith on AppConfig {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAppConfig.copyWith(...)` or `instanceOfAppConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppConfigCWProxy get copyWith => _$AppConfigCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
  configVersion: (json['configVersion'] as num).toInt(),
  ui: UiConfig.fromJson(json['ui'] as Map<String, dynamic>),
  input: InputConfig.fromJson(json['input'] as Map<String, dynamic>),
  commands:
      (json['commands'] as List<dynamic>?)
          ?.map((e) => CommandConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  provider: ProviderConfig.fromJson(json['provider'] as Map<String, dynamic>),
  debug: DebugConfig.fromJson(json['debug'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
  'configVersion': instance.configVersion,
  'ui': instance.ui.toJson(),
  'input': instance.input.toJson(),
  'commands': instance.commands.map((e) => e.toJson()).toList(),
  'provider': instance.provider.toJson(),
  'debug': instance.debug.toJson(),
};

const _$AppConfigJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'stringify': {'type': 'boolean'},
    'hashCode': {'type': 'integer'},
    'configVersion': {
      'type': 'integer',
      'description': 'Version of the config schema used for migration.',
    },
    'ui': {
      r'$ref': r'#/$defs/UiConfig',
      'description': 'Visual settings such as theme and layout.',
    },
    'input': {
      r'$ref': r'#/$defs/InputConfig',
      'description': 'Input settings such as keyboard bindings.',
    },
    'commands': {
      'type': 'array',
      'items': {r'$ref': r'#/$defs/CommandConfig'},
      'description': 'User-defined command metadata.',
    },
    'provider': {
      r'$ref': r'#/$defs/ProviderConfig',
      'description':
          'Runtime provider selection and provider-specific settings.',
    },
    'debug': {
      r'$ref': r'#/$defs/DebugConfig',
      'description': 'Debug and diagnostics behavior toggles.',
    },
    'props': {
      'type': 'array',
      'items': {'type': 'object'},
    },
  },
  'required': [
    'hashCode',
    'configVersion',
    'ui',
    'input',
    'commands',
    'provider',
    'debug',
    'props',
  ],
  r'$defs': {
    'ThemeConfig': {
      'type': 'object',
      'properties': {
        'mode': {'type': 'string'},
        'colors': {
          'type': 'object',
          'additionalProperties': {'type': 'string'},
        },
        'spacing': {
          'type': 'object',
          'additionalProperties': {'type': 'number'},
        },
        'fontSizes': {
          'type': 'object',
          'additionalProperties': {'type': 'number'},
        },
        'props': {
          'type': 'array',
          'items': {'type': 'object'},
        },
      },
      'required': ['mode', 'colors', 'spacing', 'fontSizes', 'props'],
    },
    'LayoutConfig': {
      'type': 'object',
      'properties': {
        'showLeftSidebar': {'type': 'boolean'},
        'showRightSidebar': {'type': 'boolean'},
        'showBottomPanel': {'type': 'boolean'},
        'leftSidebarWidth': {'type': 'number'},
        'rightSidebarWidth': {'type': 'number'},
        'bottomPanelHeight': {'type': 'number'},
        'slots': {
          'type': 'object',
          'additionalProperties': {'type': 'object'},
        },
        'props': {
          'type': 'array',
          'items': {'type': 'object'},
        },
      },
      'required': [
        'showLeftSidebar',
        'showRightSidebar',
        'showBottomPanel',
        'leftSidebarWidth',
        'rightSidebarWidth',
        'bottomPanelHeight',
        'slots',
        'props',
      ],
    },
    'UiConfig': {
      'type': 'object',
      'properties': {
        'theme': {r'$ref': r'#/$defs/ThemeConfig'},
        'layout': {r'$ref': r'#/$defs/LayoutConfig'},
        'props': {
          'type': 'array',
          'items': {'type': 'object'},
        },
      },
      'required': ['theme', 'layout', 'props'],
    },
    'KeybindingConfig': {
      'type': 'object',
      'properties': {
        'key': {'type': 'string'},
        'command': {'type': 'string'},
        'when': {'type': 'string'},
        'props': {
          'type': 'array',
          'items': {'type': 'object'},
        },
      },
      'required': ['key', 'command', 'props'],
    },
    'InputConfig': {
      'type': 'object',
      'properties': {
        'keybindings': {
          'type': 'array',
          'items': {r'$ref': r'#/$defs/KeybindingConfig'},
        },
        'props': {
          'type': 'array',
          'items': {'type': 'object'},
        },
      },
      'required': ['keybindings', 'props'],
    },
    'CommandConfig': {
      'type': 'object',
      'properties': {
        'id': {'type': 'string'},
        'title': {'type': 'string'},
        'icon': {'type': 'string'},
        'category': {'type': 'string'},
        'props': {
          'type': 'array',
          'items': {'type': 'object'},
        },
      },
      'required': ['id', 'title', 'props'],
    },
    'MockProviderSettings': {
      'type': 'object',
      'properties': {
        'seed': {'type': 'integer'},
        'conversationCount': {'type': 'integer'},
        'messagesPerConversation': {'type': 'integer'},
        'latencyMinMs': {'type': 'integer'},
        'latencyMaxMs': {'type': 'integer'},
        'failRate': {'type': 'number'},
        'props': {
          'type': 'array',
          'items': {'type': 'object'},
        },
      },
      'required': [
        'seed',
        'conversationCount',
        'messagesPerConversation',
        'latencyMinMs',
        'latencyMaxMs',
        'failRate',
        'props',
      ],
    },
    'ProviderConfig': {
      'type': 'object',
      'properties': {
        'type': {'type': 'string'},
        'mock': {r'$ref': r'#/$defs/MockProviderSettings'},
        'props': {
          'type': 'array',
          'items': {'type': 'object'},
        },
      },
      'required': ['type', 'props'],
    },
    'DebugConfig': {
      'type': 'object',
      'properties': {
        'showInspector': {'type': 'boolean'},
        'showEventLog': {'type': 'boolean'},
        'simulateErrors': {'type': 'boolean'},
        'logLevel': {'type': 'integer'},
        'props': {
          'type': 'array',
          'items': {'type': 'object'},
        },
      },
      'required': [
        'showInspector',
        'showEventLog',
        'simulateErrors',
        'logLevel',
        'props',
      ],
    },
  },
};
