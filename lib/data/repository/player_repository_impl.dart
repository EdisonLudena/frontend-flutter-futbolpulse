import 'package:dio/dio.dart';
import '../../domain/repository/player_repository.dart';
import '../../domain/model/jugador.dart';
import '../../domain/model/jugador_posicion.dart';
import '../remote/dto/jugador_dto.dart';
import '../remote/dto/jugador_posicion_dto.dart';
import '../remote/dto/paginated_response_dto.dart';
import '../../core/error/api_exception.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final Dio _dio;
  PlayerRepositoryImpl(this._dio);

  @override
  Future<List<Jugador>> getJugadores() async {
    try {
      final response = await _dio.get('/jugadores/');
      final paginated = PaginatedResponseDto<JugadorDto>.fromJson(
        response.data,
        (json) => JugadorDto.fromJson(json),
      );
      return paginated.results.map((dto) => dto.toDomain()).toList();
    } on DioException catch (e) {
      throw ApiException('Error al obtener plantilla', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<Jugador> createJugador(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/jugadores/', data: data);
      return JugadorDto.fromJson(response.data).toDomain();
    } on DioException catch (e) {
      throw ApiException('Error al crear jugador', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<Jugador> updateJugador(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/jugadores/$id/', data: data);
      return JugadorDto.fromJson(response.data).toDomain();
    } on DioException catch (e) {
      throw ApiException('Error al actualizar jugador', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> deleteJugador(String id) async {
    try {
      await _dio.delete('/jugadores/$id/');
    } on DioException catch (e) {
      throw ApiException('Error al eliminar jugador', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<List<JugadorPosicion>> getPosicionesJugador(String jugadorId) async {
    // CORRECCIÓN: Usar endpoint singular 'jugador-posiciones'
    final response = await _dio.get('/jugador-posiciones/', queryParameters: {'jugador': jugadorId});
    final results = response.data['results'] as List;
    return results.map((e) => JugadorPosicionDto.fromJson(e).toDomain()).toList();
  }

  @override
  Future<void> savePosicionJugador(Map<String, dynamic> data) async {
    await _dio.post('/jugador-posiciones/', data: data);
  }
}
