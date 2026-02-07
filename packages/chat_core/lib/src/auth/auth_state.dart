import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:provider_api/provider_api.dart';

part 'auth_state.g.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class Authenticating extends AuthState {
  const Authenticating();
}

@CopyWith()
class Authenticated extends AuthState {
  final ProviderSession session;

  const Authenticated(this.session);

  @override
  List<Object?> get props => [session];
}

@CopyWith()
class AuthError extends AuthState {
  final String error;
  final bool canRetry;

  const AuthError(this.error, {required this.canRetry});

  @override
  List<Object?> get props => [error, canRetry];
}
