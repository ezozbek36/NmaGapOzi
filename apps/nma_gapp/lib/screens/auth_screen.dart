import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_core/chat_core.dart';
import 'package:ui_kit/ui_kit.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _usernameController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _login() {
    final username = _usernameController.text;
    final code = _codeController.text;
    if (username.isNotEmpty && code.isNotEmpty) {
      ref.read(authBlocProvider).add(AuthLogin(username, code));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final authBloc = ref.watch(authBlocProvider);

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.colors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colors.border),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: BlocConsumer<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error), backgroundColor: theme.colors.destructive));
              }
            },
            builder: (context, state) {
              final isLoading = state is Authenticating;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Welcome Back', style: theme.typography.h3, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('Enter your credentials to access your workspace.', style: theme.typography.muted, textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  TextInput(controller: _usernameController, hintText: 'Username', autofocus: true, onSubmitted: (_) => _login()),
                  const SizedBox(height: 16),
                  TextInput(controller: _codeController, hintText: 'Access Code', obscureText: true, onSubmitted: (_) => _login()),
                  const SizedBox(height: 24),
                  Button(
                    onPressed: isLoading ? null : _login,
                    child: isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(theme.colors.background)),
                          )
                        : const Text('Login'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
