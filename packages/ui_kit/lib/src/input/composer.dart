import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ComposerInput extends StatelessWidget {
  const ComposerInput({super.key, this.controller, this.hintText, this.onChanged, this.onSubmitted, this.actions});

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colors.background,
        border: Border(top: BorderSide(color: theme.colors.border)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            style: theme.typography.p,
            maxLines: 5,
            minLines: 1,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.typography.muted,
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          if (actions != null) ...[const SizedBox(height: 8), Row(children: actions!)],
        ],
      ),
    );
  }
}
