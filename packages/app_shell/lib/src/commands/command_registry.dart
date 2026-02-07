import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef CommandHandler = void Function(BuildContext context);

class Command {
  final String id;
  final String label;
  final IconData? icon;
  final CommandHandler handler;

  const Command({required this.id, required this.label, required this.handler, this.icon});
}

final commandRegistryProvider = Provider((ref) => CommandRegistry());

class CommandRegistry {
  final Map<String, Command> _commands = {};

  void register(Command command) {
    if (_commands.containsKey(command.id)) {
      debugPrint('Warning: Overwriting command ${command.id}');
    }
    _commands[command.id] = command;
  }

  void unregister(String id) {
    _commands.remove(id);
  }

  Command? getCommand(String id) {
    return _commands[id];
  }

  List<Command> get allCommands => _commands.values.toList();

  void execute(String id, BuildContext context) {
    final command = _commands[id];
    if (command != null) {
      command.handler(context);
    } else {
      debugPrint('Command not found: $id');
    }
  }
}
