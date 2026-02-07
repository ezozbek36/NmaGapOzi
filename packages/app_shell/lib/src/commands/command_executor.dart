import 'package:flutter/widgets.dart';
import 'command_registry.dart';

class CommandExecutor {
  const CommandExecutor(this._registry);

  final CommandRegistry _registry;

  void execute(String commandId, BuildContext context) {
    _registry.execute(commandId, context);
  }
}
