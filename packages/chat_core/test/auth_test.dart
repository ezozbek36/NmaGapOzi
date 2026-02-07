import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chat_core/chat_core.dart';
import 'package:provider_api/provider_api.dart';

class MockChatProvider extends Mock implements IChatProvider {}

class MockSession extends Mock implements ProviderSession {}

void main() {
  late MockChatProvider mockProvider;

  setUpAll(() {
    registerFallbackValue(const LoginParams(username: 'u', code: 'c'));
  });

  setUp(() {
    mockProvider = MockChatProvider();
  });

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'login transitions through states correctly',
      build: () => AuthBloc(provider: mockProvider),
      act: (bloc) {
        when(
          () => mockProvider.login(any()),
        ).thenAnswer((_) async => ProviderSession(userId: '1', displayName: 'u', expiresAt: DateTime.now()));
        bloc.add(const AuthLogin('user', 'code'));
      },
      expect: () => [const Authenticating(), isA<Authenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'logout transitions back to unauthenticated',
      build: () => AuthBloc(provider: mockProvider),
      seed: () => Authenticated(ProviderSession(userId: '1', displayName: 'u', expiresAt: DateTime.now())),
      act: (bloc) {
        when(() => mockProvider.logout()).thenAnswer((_) async => {});
        bloc.add(AuthLogout());
      },
      expect: () => [const Unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'CheckStatus restores session if available',
      build: () => AuthBloc(provider: mockProvider),
      act: (bloc) {
        when(
          () => mockProvider.restoreSession(),
        ).thenAnswer((_) async => ProviderSession(userId: '1', displayName: 'u', expiresAt: DateTime.now()));
        bloc.add(AuthCheckStatus());
      },
      expect: () => [isA<Authenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'CheckStatus goes to unauthenticated if no session',
      build: () => AuthBloc(provider: mockProvider),
      act: (bloc) {
        when(() => mockProvider.restoreSession()).thenAnswer((_) async => null);
        bloc.add(AuthCheckStatus());
      },
      expect: () => [const Unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'login emits AuthError on failure',
      build: () => AuthBloc(provider: mockProvider),
      act: (bloc) {
        when(() => mockProvider.login(any())).thenThrow(Exception('Login failed'));
        bloc.add(const AuthLogin('user', 'code'));
      },
      expect: () => [const Authenticating(), isA<AuthError>()],
    );
  });
}
