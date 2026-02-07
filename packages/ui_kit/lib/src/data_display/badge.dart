import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';

class Badge extends StatelessWidget {
  const Badge({super.key, required this.count, this.maxCount = 99});

  final int count;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final theme = AppTheme.of(context);
    final text = count > maxCount ? '$maxCount+' : '$count';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: theme.colors.accent, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: theme.typography.small.copyWith(fontSize: 10, color: theme.colors.accentForeground)),
    );
  }
}

enum Status { online, away, busy, offline }

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status, this.size = 10});

  final Status status;
  final double size;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case Status.online:
        color = const Color(0xFF22C55E);
      case Status.away:
        color = const Color(0xFFEAB308);
      case Status.busy:
        color = const Color(0xFFEF4444);
      case Status.offline:
        color = const Color(0xFF71717A);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFFFFF), width: 1.5),
      ),
    );
  }
}
