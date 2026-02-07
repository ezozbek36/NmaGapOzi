import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.imageUrl, this.initials, this.size = 32});

  final String? imageUrl;
  final String? initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colors.accent,
        shape: BoxShape.circle,
        border: Border.all(color: theme.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildInitials(theme),
              )
            : _buildInitials(theme),
      ),
    );
  }

  Widget _buildInitials(AppTheme theme) {
    return Text(
      initials?.toUpperCase() ?? '?',
      style: theme.typography.small.copyWith(fontSize: size * 0.4, color: theme.colors.accentForeground),
    );
  }
}
