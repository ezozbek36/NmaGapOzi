import '../schema/app_config.dart';
import '../schema/ui_config.dart';
import '../schema/theme_config.dart';
import '../schema/layout_config.dart';
import '../schema/input_config.dart';
import '../schema/command_config.dart';
import '../schema/provider_config.dart';
import '../schema/debug_config.dart';

class DefaultConfig {
  static AppConfig get value => const AppConfig(
    configVersion: 1,
    ui: UiConfig(
      theme: ThemeConfig(
        mode: 'system',
        colors: {'primary': '#6366f1', 'background': '#0f172a', 'surface': '#1e293b', 'text': '#f8fafc', 'textSecondary': '#94a3b8'},
        spacing: {'xs': 4.0, 'sm': 8.0, 'md': 16.0, 'lg': 24.0, 'xl': 32.0},
        fontSizes: {'sm': 12.0, 'base': 14.0, 'lg': 16.0, 'xl': 20.0},
      ),
      layout: LayoutConfig(
        showLeftSidebar: true,
        showRightSidebar: false,
        showBottomPanel: true,
        leftSidebarWidth: 280.0,
        rightSidebarWidth: 280.0,
        bottomPanelHeight: 200.0,
      ),
    ),
    input: InputConfig(
      keybindings: [
        KeybindingConfig(key: 'ctrl+k', command: 'command_palette.open'),
        KeybindingConfig(key: 'ctrl+,', command: 'settings.open'),
      ],
    ),
    commands: [
      CommandConfig(id: 'command_palette.open', title: 'Open Command Palette'),
      CommandConfig(id: 'settings.open', title: 'Open Settings'),
    ],
    provider: ProviderConfig(type: 'mock', mock: MockProviderSettings()),
    debug: DebugConfig(),
  );
}
