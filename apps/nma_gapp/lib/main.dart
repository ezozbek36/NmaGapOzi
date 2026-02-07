import 'package:chat_core/chat_core.dart';
import 'package:config_core/config_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider_mock/provider_mock.dart';
import 'package:app_shell/app_shell.dart';
import 'app.dart';
import 'wiring/slot_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load config
  final configLoader = ConfigLoader();
  final config = await configLoader.load();

  // 2. Setup Provider
  final mockSettings = config.provider.mock ?? const MockProviderSettings();
  final mockConfig = MockProviderConfig(
    seed: mockSettings.seed,
    conversationCount: mockSettings.conversationCount,
    messagesPerConversation: mockSettings.messagesPerConversation,
    latencyMinMs: mockSettings.latencyMinMs,
    latencyMaxMs: mockSettings.latencyMaxMs,
    failRate: mockSettings.failRate,
  );

  final chatProvider = MockChatProvider(config: mockConfig);

  final container = ProviderContainer(
    overrides: [configLoaderProvider.overrideWithValue(configLoader), chatProviderProvider.overrideWithValue(chatProvider)],
  );

  // 3. Register slots before app starts
  SlotConfig.register(container.read(slotRegistryProvider.notifier));

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
