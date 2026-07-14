import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/usuario.dart';
import 'repository_providers.dart';
import 'subscription_provider.dart';

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final Usuario? user;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isChecking => status == AuthStatus.checking;

  AuthState copyWith({
    AuthStatus? status,
    Usuario? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _restoreSession();
    return AuthState(status: AuthStatus.checking);
  }

  Future<void> _restoreSession() async {
    try {
      final user = await ref.read(authRepositoryProvider).getLoggedUser();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.checking, errorMessage: null);
    try {
      final result = await ref.read(authRepositoryProvider).login(email, password);
      final user = result.$3 ?? await ref.read(authRepositoryProvider).getLoggedUser();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, errorMessage: e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String password2,
    required String nombreCompleto,
    required String tipoUsuario,
  }) async {
    state = state.copyWith(status: AuthStatus.checking);
    try {
      await ref.read(authRepositoryProvider).register(
        email: email,
        password: password,
        password2: password2,
        nombreCompleto: nombreCompleto,
        tipoUsuario: tipoUsuario,
      );
      state = AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    // IMPORTANTE: Primero notificamos al repositorio para borrar tokens del storage
    await ref.read(authRepositoryProvider).logout();
    // Luego cambiamos el estado. Esto disparará automáticamente el reset de SubscriptionProvider
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
