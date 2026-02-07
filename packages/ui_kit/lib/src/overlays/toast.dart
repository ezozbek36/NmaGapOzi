import 'dart:async';
import 'package:flutter/widgets.dart';
import '../theme/app_theme.dart';

class Toast {
  const Toast({required this.id, required this.message, this.type = ToastType.info, this.duration = const Duration(seconds: 3)});

  final String id;
  final String message;
  final ToastType type;
  final Duration duration;
}

enum ToastType { info, success, error }

class ToastOverlay extends StatefulWidget {
  const ToastOverlay({super.key, required this.child});

  final Widget child;

  static _ToastOverlayState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_ToastOverlayState>();
    assert(state != null, 'No ToastOverlay found in context');
    return state!;
  }

  @override
  State<ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<ToastOverlay> {
  final List<Toast> _toasts = [];

  void show(String message, {ToastType type = ToastType.info}) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final toast = Toast(id: id, message: message, type: type);
    setState(() {
      _toasts.add(toast);
    });
    Timer(toast.duration, () {
      if (mounted) {
        setState(() {
          _toasts.removeWhere((t) => t.id == id);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Stack(
      children: [
        widget.child,
        Positioned(
          bottom: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _toasts.map((toast) => _ToastWidget(toast: toast, theme: theme)).toList(),
          ),
        ),
      ],
    );
  }
}

class _ToastWidget extends StatelessWidget {
  const _ToastWidget({required this.toast, required this.theme});

  final Toast toast;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    switch (toast.type) {
      case ToastType.info:
        bgColor = theme.colors.surface;
      case ToastType.success:
        bgColor = const Color(0xFF166534); // success-dark
      case ToastType.error:
        bgColor = theme.colors.destructive;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: theme.colors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        toast.message,
        style: theme.typography.p.copyWith(
          color: toast.type == ToastType.info ? theme.colors.foreground : theme.colors.destructiveForeground,
        ),
      ),
    );
  }
}
