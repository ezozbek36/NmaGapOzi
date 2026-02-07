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
  static Future<String> getConfigDir() async {
    if (Platform.isLinux) {
      final configHome = Platform.environment['XDG_CONFIG_HOME'];
      if (configHome != null && configHome.isNotEmpty) {
        return p.join(configHome, _appName);
      }
      final home = Platform.environment['HOME'];
      if (home != null && home.isNotEmpty) {
        return p.join(home, '.config', _appName);
      }
    }

    // For macOS and Windows, getApplicationSupportDirectory gives us the standard location.
    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
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
