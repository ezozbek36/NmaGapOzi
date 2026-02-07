import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:provider_api/provider_api.dart';
import 'auth_state.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthLogin extends AuthEvent {
  final String username;
  final String code;

  const AuthLogin(this.username, this.code);

  @override
  List<Object?> get props => [username, code];
}

class AuthLogout extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IChatProvider _provider;

  AuthBloc({required IChatProvider provider}) : _provider = provider, super(const Unauthenticated()) {
    on<AuthLogin>(_onLogin);
    on<AuthLogout>(_onLogout);
    on<AuthCheckStatus>(_onCheckStatus);
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(const Authenticating());
    try {
      final session = await _provider.login(LoginParams(username: event.username, code: event.code));
      emit(Authenticated(session));
    } catch (e) {
      emit(AuthError(e.toString(), canRetry: true));
    }
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    try {
      await _provider.logout();
    } catch (_) {}
    emit(const Unauthenticated());
  }

  Future<void> _onCheckStatus(AuthCheckStatus event, Emitter<AuthState> emit) async {
    try {
      final session = await _provider.restoreSession();
      if (session != null) {
        emit(Authenticated(session));
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(const Unauthenticated());
    }
  }
}
