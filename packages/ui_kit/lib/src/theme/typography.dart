import 'package:flutter/widgets.dart';

class AppTypography {
  const AppTypography({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.p,
    required this.small,
    required this.large,
    required this.lead,
    required this.muted,
    required this.mono,
  });

  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle p;
  final TextStyle small;
  final TextStyle large;
  final TextStyle lead;
  final TextStyle muted;
  final TextStyle mono;

  static AppTypography standard(Color foreground, Color mutedForeground) {
    return AppTypography(
      h1: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: foreground),
      h2: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: foreground),
      h3: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: foreground),
      p: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: foreground),
      small: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: foreground),
      large: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: foreground),
      lead: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: mutedForeground),
      muted: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: mutedForeground),
      mono: TextStyle(fontSize: 14, fontFamily: 'monospace', color: foreground),
    );
  }
}
