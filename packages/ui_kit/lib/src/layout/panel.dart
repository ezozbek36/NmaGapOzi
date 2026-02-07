import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';

class Panel extends StatelessWidget {
  const Panel({super.key, this.header, required this.body, this.footer, this.border = true});

  final Widget? header;
  final Widget body;
  final Widget? footer;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final header = this.header;
    final footer = this.footer;

    return Container(
      decoration: BoxDecoration(
        color: theme.colors.background,
        border: border ? Border.all(color: theme.colors.border) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?header,
          Expanded(child: body),
          ?footer,
        ],
      ),
    );
  }
}

class PanelHeader extends StatelessWidget {
  const PanelHeader({super.key, required this.title, this.actions});

  final Widget title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.border)),
      ),
      child: Row(
        children: [
          DefaultTextStyle(style: theme.typography.small, child: title),
          const Spacer(),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

class PanelBody extends StatelessWidget {
  const PanelBody({super.key, required this.child, this.padding = const EdgeInsets.all(12), this.scrollable = true});

  final Widget child;
  final EdgeInsets padding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(padding: padding, child: child);

    if (scrollable) {
      content = SingleChildScrollView(child: content);
    }

    return content;
  }
}

class PanelFooter extends StatelessWidget {
  const PanelFooter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colors.border)),
      ),
      child: DefaultTextStyle(
        style: theme.typography.small.copyWith(color: theme.colors.mutedForeground),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }
}
