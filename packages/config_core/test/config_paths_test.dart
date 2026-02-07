import 'package:config_core/src/loading/config_paths.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('ConfigPaths', () {
    const appName = 'nmagapozi';

    test('Linux: uses XDG_CONFIG_HOME when present', () async {
      final dir = await ConfigPaths.getConfigDir(
        isLinux: true,
        isMacOS: false,
        isWindows: false,
        environment: {'XDG_CONFIG_HOME': '/custom/config'},
      );
      expect(dir, '/custom/config/$appName');
    });

    test('Linux: falls back to ~/.config when XDG_CONFIG_HOME is missing', () async {
      final dir = await ConfigPaths.getConfigDir(isLinux: true, isMacOS: false, isWindows: false, environment: {'HOME': '/home/user'});
      expect(dir, '/home/user/.config/$appName');
    });

    test('macOS: resolves to Library/Application Support', () async {
      final dir = await ConfigPaths.getConfigDir(isLinux: false, isMacOS: true, isWindows: false, environment: {'HOME': '/Users/user'});
      expect(dir, '/Users/user/Library/Application Support/$appName');
    });

    test('Windows: resolves to APPDATA', () async {
      const appData = r'C:\Users\user\AppData\Roaming';
      final dir = await ConfigPaths.getConfigDir(isLinux: false, isMacOS: false, isWindows: true, environment: {'APPDATA': appData});
      // Use path.join to match the behavior of the current platform's path context
      expect(dir, p.join(appData, appName));
    });

    test('Throws UnsupportedError for unknown platform', () async {
      expect(
        () => ConfigPaths.getConfigDir(isLinux: false, isMacOS: false, isWindows: false, environment: {}),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('getConfigPath appends filename', () async {
      // This test will use the current platform but we can check the logic
      final path = await ConfigPaths.getConfigPath();
      expect(path, endsWith('config.yaml'));
    });
  });
}
