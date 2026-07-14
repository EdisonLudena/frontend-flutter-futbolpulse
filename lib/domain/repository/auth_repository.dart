import '../model/usuario.dart';

abstract class AuthRepository {
  // Ahora devolvemos también el usuario si el backend lo incluyó en el login
  Future<(String access, String refresh, Usuario? user)> login(String email, String password);
  
  Future<void> register({
    required String email,
    required String password,
    required String password2,
    required String nombreCompleto,
    required String tipoUsuario,
  });

  Future<void> logout();
  Future<Usuario> getLoggedUser();
  Future<String> refreshToken(String refresh);
}
