import 'package:flutter/widgets.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme extends InheritedWidget {
  const AppTheme({super.key, required this.colors, required this.typography, required super.child});

  final AppColors colors;
  final AppTypography typography;

  static AppTheme of(BuildContext context) {
    final AppTheme? result = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    assert(result != null, 'No AppTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget) {
    return colors != oldWidget.colors || typography != oldWidget.typography;
  }
}

class AppThemeProvider extends StatelessWidget {
  const AppThemeProvider({super.key, required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = isDark ? AppColors.dark : AppColors.light;
    final typography = AppTypography.standard(colors.foreground, colors.mutedForeground);

    return AppTheme(colors: colors, typography: typography, child: child);
  }
}
