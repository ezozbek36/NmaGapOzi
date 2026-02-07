import 'dart:io';
import 'package:path/path.dart' as p;

class ConfigPaths {
  static const String _configFileName = 'config.yaml';
  static const String _appName = 'nmagapozi';

  /// Returns the directory where configuration files are stored.
  ///
  /// Linux: ~/.config/nmagapozi/
  /// macOS: ~/Library/Application Support/nmagapozi/
  /// Windows: %APPDATA%/nmagapozi/
  static Future<String> getConfigDir({bool? isLinux, bool? isMacOS, bool? isWindows, Map<String, String>? environment}) async {
    final bool linux = isLinux ?? Platform.isLinux;
    final bool macos = isMacOS ?? Platform.isMacOS;
    final bool windows = isWindows ?? Platform.isWindows;
    final Map<String, String> env = environment ?? Platform.environment;

    if (linux) {
      final configHome = env['XDG_CONFIG_HOME'];
      if (configHome != null && configHome.isNotEmpty) {
        return p.join(configHome, _appName);
      }
      final home = env['HOME'];
      if (home != null && home.isNotEmpty) {
        return p.join(home, '.config', _appName);
      }
    }

    if (macos) {
      final home = env['HOME'];
      if (home != null && home.isNotEmpty) {
        return p.join(home, 'Library', 'Application Support', _appName);
      }
    }

    if (windows) {
      final appData = env['APPDATA'];
      if (appData != null && appData.isNotEmpty) {
        return p.join(appData, _appName);
      }
    }

    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }

  static Future<String> getConfigPath() async {
    final dir = await getConfigDir();
    return p.join(dir, _configFileName);
  }
}
