import 'package:flutter/widgets.dart';

class AppColors {
  const AppColors({
    required this.background,
    required this.foreground,
    required this.surface,
    required this.border,
    required this.accent,
    required this.accentForeground,
    required this.muted,
    required this.mutedForeground,
    required this.destructive,
    required this.destructiveForeground,
  });

  final Color background;
  final Color foreground;
  final Color surface;
  final Color border;
  final Color accent;
  final Color accentForeground;
  final Color muted;
  final Color mutedForeground;
  final Color destructive;
  final Color destructiveForeground;

  static const dark = AppColors(
    background: Color(0xFF09090B),
    foreground: Color(0xFFFAFAFA),
    surface: Color(0xFF18181B),
    border: Color(0xFF27272A),
    accent: Color(0xFF3F3F46),
    accentForeground: Color(0xFFFAFAFA),
    muted: Color(0xFF18181B),
    mutedForeground: Color(0xFFA1A1AA),
    destructive: Color(0xFF7F1D1D),
    destructiveForeground: Color(0xFFFAFAFA),
  );

  static const light = AppColors(
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF09090B),
    surface: Color(0xFFF4F4F5),
    border: Color(0xFFE4E4E7),
    accent: Color(0xFFF4F4F5),
    accentForeground: Color(0xFF18181B),
    muted: Color(0xFFF4F4F5),
    mutedForeground: Color(0xFF71717A),
    destructive: Color(0xFFEF4444),
    destructiveForeground: Color(0xFFFAFAFA),
  );
}
