import 'package:dio/dio.dart';
import '../../domain/repository/competition_repository.dart';
import '../../domain/model/partido.dart';
import '../../domain/model/alineacion.dart';
import '../../domain/model/evaluacion_post_partido.dart';
import '../../domain/model/jugador.dart';
import '../remote/dto/jugador_dto.dart';
import '../remote/dto/partido_dto.dart';
import '../remote/dto/alineacion_dto.dart';
import '../remote/dto/evaluacion_post_partido_dto.dart';
import '../remote/dto/paginated_response_dto.dart';
import '../../core/error/api_exception.dart';

class CompetitionRepositoryImpl implements CompetitionRepository {
  final Dio _dio;
  CompetitionRepositoryImpl(this._dio);

  @override
  Future<List<Partido>> getPartidos({String? categoriaId}) async {
    try {
      final queryParams = categoriaId != null ? {'categoria': categoriaId} : null;
      final response = await _dio.get('/partidos/', queryParameters: queryParams);
      final paginated = PaginatedResponseDto<PartidoDto>.fromJson(
        response.data,
        (json) => PartidoDto.fromJson(json),
      );
      return paginated.results.map((dto) => dto.toDomain()).toList();
    } on DioException catch (e) {
      throw ApiException('Error al obtener partidos', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<Partido> getPartido(String id) async {
    try {
      final response = await _dio.get('/partidos/$id/');
      return PartidoDto.fromJson(response.data).toDomain();
    } on DioException catch (e) {
      throw ApiException('Error al obtener el partido', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<Partido> createPartido(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/partidos/', data: data);
      return PartidoDto.fromJson(response.data).toDomain();
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Error al crear partido';
      if (errorData is Map) {
        message = errorData.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      }
      throw ApiException(message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<Partido> updatePartido(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/partidos/$id/', data: data);
      return PartidoDto.fromJson(response.data).toDomain();
    } on DioException catch (e) {
      throw ApiException('Error al actualizar partido', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> deletePartido(String id) async {
    try {
      await _dio.delete('/partidos/$id/');
    } on DioException catch (e) {
      throw ApiException('Error al eliminar partido', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<List<Alineacion>> getAlineaciones(String partidoId) async {
    try {
      final response = await _dio.get('/alineaciones/', queryParameters: {'partido': partidoId});
      final paginated = PaginatedResponseDto<AlineacionDto>.fromJson(
        response.data,
        (json) => AlineacionDto.fromJson(json),
      );
      return paginated.results.map((dto) => dto.toDomain()).toList();
    } on DioException catch (e) {
      throw ApiException('Error al obtener alineaciones', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> saveAlineacion(Map<String, dynamic> data) async {
    try {
      await _dio.post('/alineaciones/', data: data);
    } on DioException catch (e) {
      throw ApiException('Error al guardar alineación', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> deleteAlineacion(String id) async {
    try {
      await _dio.delete('/alineaciones/$id/');
    } on DioException catch (e) {
      throw ApiException('Error al eliminar alineación', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> createEventoLive(Map<String, dynamic> data) async {
    try {
      await _dio.post('/eventos-live/', data: data);
    } on DioException catch (e) {
      throw ApiException('Error al registrar evento', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<List<dynamic>> getEventosLive(String partidoId) async {
    try {
      final response = await _dio.get('/eventos-live/', queryParameters: {'partido': partidoId});
      if (response.data is Map && response.data.containsKey('results')) {
        return response.data['results'];
      }
      return response.data as List;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveEvaluacion(Map<String, dynamic> data) async {
    try {
      await _dio.post('/evaluacion-post-partido/', data: data);
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Error al guardar evaluación';
      if (errorData is Map) {
        if (errorData.containsKey('non_field_errors')) {
          message = 'Ya existe una evaluación para este jugador en este partido.';
        } else {
          message = errorData.entries.map((e) => '${e.key}: ${e.value}').join(', ');
        }
      }
      throw ApiException(message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> updateEvaluacion(String id, Map<String, dynamic> data) async {
    try {
      await _dio.patch('/evaluacion-post-partido/$id/', data: data);
    } on DioException catch (e) {
      throw ApiException('Error al actualizar evaluación', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> deleteEvaluacion(String id) async {
    try {
      await _dio.delete('/evaluacion-post-partido/$id/');
    } on DioException catch (e) {
      throw ApiException('Error al eliminar evaluación', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<List<EvaluacionPostPartido>> getEvaluaciones({String? jugadorId}) async {
    try {
      final queryParams = jugadorId != null ? {'jugador': jugadorId} : null;
      final response = await _dio.get('/evaluacion-post-partido/', queryParameters: queryParams);
      final paginated = PaginatedResponseDto<EvaluacionPostPartidoDto>.fromJson(
        response.data,
        (json) => EvaluacionPostPartidoDto.fromJson(json),
      );
      return paginated.results.map((dto) => dto.toDomain()).toList();
    } on DioException catch (e) {
      throw ApiException('Error al obtener evaluaciones', statusCode: e.response?.statusCode);
    }
  }

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
      throw ApiException('Error al obtener jugadores', statusCode: e.response?.statusCode);
    }
  }
}
