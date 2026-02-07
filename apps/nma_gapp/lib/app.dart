import 'package:app_shell/app_shell.dart';
import 'package:chat_core/chat_core.dart';
import 'package:config_core/config_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';
import 'screens/auth_screen.dart';
import 'wiring/slot_config.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Register slots once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SlotConfig.register(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final themeConfig = config.ui.theme;
    final isDark = themeConfig.mode == 'dark';

    return MaterialApp(
      title: 'NmaGapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFFFFFFF),
      ),
      builder: (context, child) {
        return AppThemeProvider(isDark: isDark, child: child!);
      },
      home: BlocBuilder<AuthBloc, AuthState>(
        bloc: ref.watch(authBlocProvider),
        builder: (context, state) {
          if (state is Authenticated) {
            return const AppShell();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
