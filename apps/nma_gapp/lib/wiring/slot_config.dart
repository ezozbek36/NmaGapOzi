import 'package:app_shell/app_shell.dart';
import '../screens/chat_list_screen.dart';
import '../screens/message_list_screen.dart';
import '../widgets/composer.dart';

class SlotConfig {
  static void register(SlotRegistry registry) {
    // Left Sidebar: Chat List
    registry.register('left_sidebar', (context) => const ChatListScreen());

    // Center: Message List
    registry.register('main_content', (context) => const MessageListScreen());

    // Bottom Panel: Composer
    registry.register('bottom_panel', (context) => const MessageComposer());
  }
}
