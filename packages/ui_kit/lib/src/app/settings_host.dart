import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';
import '../layout/panel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.title, required this.sections});

  final String title;
  final List<SettingsSection> sections;

  @override
  Widget build(BuildContext context) {
    return Panel(
      header: PanelHeader(title: Text(title)),
      body: PanelBody(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: sections),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.tiles});

  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(title, style: theme.typography.large),
        ),
        ...tiles,
        const SizedBox(height: 24),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, required this.title, this.subtitle, required this.trailing, this.onTap});

  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.colors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.typography.p),
                  if (subtitle != null) Text(subtitle!, style: theme.typography.muted),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
