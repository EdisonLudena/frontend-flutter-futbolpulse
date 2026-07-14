import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/model/usuario.dart';
import '../local/secure_storage.dart';
import '../remote/dto/usuario_dto.dart';
import '../../core/error/api_exception.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final SecureStorage _storage;

  AuthRepositoryImpl(this._dio, this._storage);

  @override
  Future<(String, String, Usuario?)> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login/', data: {
        'email': email,
        'password': password,
      });
      
      final access = response.data['access'] as String;
      final refresh = response.data['refresh'] as String;
      
      await _storage.saveTokens(access, refresh);
      
      final userMap = response.data['user'] ?? response.data;
      Usuario? user;
      
      // Intentamos extraer el ID de varias formas posibles en DRF
      final String? foundId = userMap['id']?.toString() ?? 
                            userMap['user_id']?.toString() ?? 
                            userMap['pk']?.toString() ??
                            userMap['uuid']?.toString();

      if (foundId != null && foundId.isNotEmpty) {
        user = UsuarioDto.fromJson(Map<String, dynamic>.from(userMap)).toDomain();
        // Aseguramos que el ID extraído manualmente se use si el DTO falló
        if (user.id.isEmpty) {
           user = user.copyWith(id: foundId);
        }

        final currentUser = user; // Local variable for null promotion
        if (currentUser != null) {
          await _storage.saveUserData(
            id: currentUser.id,
            name: currentUser.nombreCompleto,
            email: currentUser.email,
            role: currentUser.tipoUsuario,
          );
        }
      }

      return (access, refresh, user);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data['detail'] ?? 'Error de autenticación: Credenciales inválidas',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      final refresh = await _storage.getRefreshToken();
      await _storage.clear();
      if (refresh != null) {
        await _dio.post('/auth/logout/', data: {'refresh': refresh});
      }
    } catch (_) {}
  }

  @override
  Future<Usuario> getLoggedUser() async {
    final data = await _storage.getUserData();
    if (data['id'] != null) {
      return Usuario(
        id: data['id']!,
        email: data['email'] ?? '',
        nombreCompleto: data['name'] ?? '',
        tipoUsuario: data['role'] ?? 'Coach', // Por defecto Coach para evitar el fallback a Player
        estado: 'Activo',
        fechaRegistro: DateTime.now(),
        idioma: 'es',
        unidadMedida: 'Metrico',
        notificacionesActivas: true,
      );
    }
    throw ApiException('Sesión no encontrada');
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String password2,
    required String nombreCompleto,
    required String tipoUsuario,
  }) async {
    try {
      await _dio.post('/auth/register/', data: {
        'email': email,
        'password': password,
        'password2': password2,
        'nombre_completo': nombreCompleto,
        'tipo_usuario': tipoUsuario,
      });
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data['detail'] ?? 'Error al registrarse. Verifica los datos.',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> refreshToken(String refresh) async {
    try {
      final response = await _dio.post('/auth/token/refresh/', data: {'refresh': refresh});
      return response.data['access'] as String;
    } catch (_) {
      await _storage.clear();
      throw ApiException('Sesión expirada');
    }
  }
}
