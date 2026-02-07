import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommandPaletteController extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;
  void hide() => state = false;
  void toggle() => state = !state;
}

final commandPaletteControllerProvider = NotifierProvider<CommandPaletteController, bool>(CommandPaletteController.new);
