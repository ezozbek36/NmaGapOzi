import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';

class TabItemData {
  const TabItemData({required this.id, required this.label, this.icon, this.closable = true});

  final String id;
  final String label;
  final IconData? icon;
  final bool closable;
}

class TabBar extends StatelessWidget {
  const TabBar({super.key, required this.tabs, required this.selectedTabId, required this.onTabSelected, this.onTabClosed});

  final List<TabItemData> tabs;
  final String selectedTabId;
  final ValueChanged<String> onTabSelected;
  final ValueChanged<String>? onTabClosed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: theme.colors.muted,
        border: Border(bottom: BorderSide(color: theme.colors.border)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = tab.id == selectedTabId;

          return TabItem(
            data: tab,
            isSelected: isSelected,
            onTap: () => onTabSelected(tab.id),
            onClose: tab.closable ? () => onTabClosed?.call(tab.id) : null,
          );
        },
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  const TabItem({super.key, required this.data, required this.isSelected, required this.onTap, this.onClose});

  final TabItemData data;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colors.background : Color(0x00000000),
          border: Border(
            right: BorderSide(color: theme.colors.border),
            top: isSelected ? BorderSide(color: theme.colors.accent, width: 2) : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (data.icon != null) ...[
              Icon(data.icon, size: 14, color: isSelected ? theme.colors.foreground : theme.colors.mutedForeground),
              const SizedBox(width: 8),
            ],
            Text(
              data.label,
              style: theme.typography.small.copyWith(color: isSelected ? theme.colors.foreground : theme.colors.mutedForeground),
            ),
            if (onClose != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  // Prevent tapping the tab itself
                  onClose!();
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(
                    const IconData(0xe16a, fontFamily: 'MaterialIcons'), // close
                    size: 14,
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TabView extends StatelessWidget {
  const TabView({super.key, required this.selectedTabId, required this.children});

  final String selectedTabId;
  final Map<String, Widget> children;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(index: children.keys.toList().indexOf(selectedTabId), children: children.values.toList());
  }
}
