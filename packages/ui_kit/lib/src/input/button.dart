import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';

enum ButtonVariant { primary, secondary, ghost, destructive }

class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonVariant variant;
  final ButtonSize size;

  @override
  State<Button> createState() => _ButtonState();
}

enum ButtonSize { small, medium, large }

class _ButtonState extends State<Button> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isEnabled = widget.onPressed != null;

    Color bgColor;
    Color fgColor;

    switch (widget.variant) {
      case ButtonVariant.primary:
        bgColor = isEnabled ? theme.colors.foreground : theme.colors.muted;
        fgColor = theme.colors.background;
      case ButtonVariant.secondary:
        bgColor = isEnabled ? theme.colors.muted : theme.colors.muted.withOpacity(0.5);
        fgColor = theme.colors.foreground;
      case ButtonVariant.ghost:
        bgColor = _isHovering ? theme.colors.accent : Color(0x00000000);
        fgColor = theme.colors.foreground;
      case ButtonVariant.destructive:
        bgColor = isEnabled ? theme.colors.destructive : theme.colors.muted;
        fgColor = theme.colors.destructiveForeground;
    }

    double height;
    EdgeInsets padding;
    TextStyle textStyle;

    switch (widget.size) {
      case ButtonSize.small:
        height = 32;
        padding = const EdgeInsets.symmetric(horizontal: 12);
        textStyle = theme.typography.small;
      case ButtonSize.medium:
        height = 40;
        padding = const EdgeInsets.symmetric(horizontal: 16);
        textStyle = theme.typography.p;
      case ButtonSize.large:
        height = 48;
        padding = const EdgeInsets.symmetric(horizontal: 24);
        textStyle = theme.typography.large;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
          child: Center(
            child: DefaultTextStyle(
              style: textStyle.copyWith(color: fgColor),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class IconButton extends StatelessWidget {
  const IconButton({super.key, required this.onPressed, required this.icon, this.size = 32});

  final VoidCallback? onPressed;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Button(
      onPressed: onPressed,
      variant: ButtonVariant.ghost,
      size: ButtonSize.small,
      child: Icon(icon, size: size * 0.6, color: theme.colors.foreground),
    );
  }
}
