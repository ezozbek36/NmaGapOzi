import 'package:flutter/material.dart'; // Using Material for some basic widgets like ListView and TextField
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class Command {
  const Command({required this.id, required this.label, this.description, this.icon, required this.onExecute});

  final String id;
  final String label;
  final String? description;
  final IconData? icon;
  final VoidCallback onExecute;
}

class CommandPalette extends StatefulWidget {
  const CommandPalette({super.key, required this.commands, required this.onClose});

  final List<Command> commands;
  final VoidCallback onClose;

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 0;
  List<Command> _filteredCommands = [];

  @override
  void initState() {
    super.initState();
    _filteredCommands = widget.commands;
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterCommands(String query) {
    setState(() {
      _filteredCommands = widget.commands
          .where(
            (cmd) =>
                cmd.label.toLowerCase().contains(query.toLowerCase()) ||
                (cmd.description?.toLowerCase().contains(query.toLowerCase()) ?? false),
          )
          .toList();
      _selectedIndex = 0;
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % _filteredCommands.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _selectedIndex = (_selectedIndex - 1 + _filteredCommands.length) % _filteredCommands.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_filteredCommands.isNotEmpty) {
          _filteredCommands[_selectedIndex].onExecute();
          widget.onClose();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        widget.onClose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return KeyboardListener(
      focusNode: FocusNode(), // Dummy focus node for the listener
      onKeyEvent: _handleKeyEvent,
      child: Center(
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            color: theme.colors.background,
            border: Border.all(color: theme.colors.border),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    onChanged: _filterCommands,
                    style: theme.typography.p,
                    decoration: InputDecoration(
                      hintText: 'Type a command or search...',
                      hintStyle: theme.typography.muted,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Divider(height: 1, color: theme.colors.border),
                Flexible(
                  child: ListView.builder(
                    itemCount: _filteredCommands.length,
                    itemBuilder: (context, index) {
                      final command = _filteredCommands[index];
                      final isSelected = index == _selectedIndex;

                      return GestureDetector(
                        onTap: () {
                          command.onExecute();
                          widget.onClose();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          color: isSelected ? theme.colors.accent : null,
                          child: Row(
                            children: [
                              if (command.icon != null) ...[
                                Icon(
                                  command.icon,
                                  size: 18,
                                  color: isSelected ? theme.colors.accentForeground : theme.colors.mutedForeground,
                                ),
                                const SizedBox(width: 12),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      command.label,
                                      style: theme.typography.p.copyWith(
                                        color: isSelected ? theme.colors.accentForeground : theme.colors.foreground,
                                      ),
                                    ),
                                    if (command.description != null)
                                      Text(
                                        command.description!,
                                        style: theme.typography.small.copyWith(
                                          color: isSelected ? theme.colors.accentForeground.withOpacity(0.8) : theme.colors.mutedForeground,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
