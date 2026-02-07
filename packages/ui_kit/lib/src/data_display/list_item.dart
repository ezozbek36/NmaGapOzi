import 'package:flutter/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import '../theme/app_theme.dart';

class SuperListView extends StatelessWidget {
  const SuperListView({super.key, required this.itemCount, required this.itemBuilder, this.controller, this.reverse = false, this.padding});

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollController? controller;
  final bool reverse;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      reverse: reverse,
      slivers: [
        if (padding != null) SliverPadding(padding: padding!),
        SuperSliverList(delegate: SliverChildBuilderDelegate(itemBuilder, childCount: itemCount)),
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({super.key, this.leading, required this.title, this.subtitle, this.trailing, this.onTap, this.selected = false});

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: selected ? theme.colors.accent : Color(0x00000000),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: theme.typography.p.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      color: selected ? theme.colors.accentForeground : theme.colors.foreground,
                    ),
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    DefaultTextStyle(
                      style: theme.typography.small.copyWith(
                        color: selected ? theme.colors.accentForeground.withOpacity(0.7) : theme.colors.mutedForeground,
                      ),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              DefaultTextStyle(
                style: theme.typography.small.copyWith(
                  color: selected ? theme.colors.accentForeground.withOpacity(0.7) : theme.colors.mutedForeground,
                ),
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Text(title.toUpperCase(), style: theme.typography.small.copyWith(color: theme.colors.mutedForeground, letterSpacing: 1.2)),
    );
  }
}
