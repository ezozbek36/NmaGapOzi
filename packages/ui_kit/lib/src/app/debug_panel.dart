import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';
import '../layout/panel.dart';
import '../layout/tabs.dart';
import '../input/button.dart';

class DebugPanel extends StatefulWidget {
  const DebugPanel({super.key, required this.configJson, required this.eventLogs, required this.onAction});

  final String configJson;
  final List<String> eventLogs;
  final Function(String action) onAction;

  @override
  State<DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends State<DebugPanel> {
  String _selectedTab = 'config';

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Panel(
      header: PanelHeader(
        title: const Text('DEBUG CONSOLE'),
        actions: [
          IconButton(
            onPressed: () => widget.onAction('close'),
            icon: const IconData(0xe16a, fontFamily: 'MaterialIcons'),
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            tabs: const [
              TabItemData(id: 'config', label: 'Config', closable: false),
              TabItemData(id: 'logs', label: 'Logs', closable: false),
              TabItemData(id: 'actions', label: 'Actions', closable: false),
            ],
            selectedTabId: _selectedTab,
            onTabSelected: (id) => setState(() => _selectedTab = id),
          ),
          Expanded(
            child: TabView(
              selectedTabId: _selectedTab,
              children: {'config': _buildConfigView(theme), 'logs': _buildLogsView(theme), 'actions': _buildActionsView(theme)},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigView(AppTheme theme) {
    return PanelBody(child: Text(widget.configJson, style: theme.typography.mono));
  }

  Widget _buildLogsView(AppTheme theme) {
    return ListView.builder(
      itemCount: widget.eventLogs.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: theme.colors.border)),
          ),
          child: Text(widget.eventLogs[index], style: theme.typography.mono.copyWith(fontSize: 12)),
        );
      },
    );
  }

  Widget _buildActionsView(AppTheme theme) {
    return PanelBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Button(
            onPressed: () => widget.onAction('simulate_error'),
            variant: ButtonVariant.destructive,
            child: const Text('Simulate Error'),
          ),
          const SizedBox(height: 8),
          Button(onPressed: () => widget.onAction('force_reload'), variant: ButtonVariant.secondary, child: const Text('Force Reload')),
        ],
      ),
    );
  }
}
