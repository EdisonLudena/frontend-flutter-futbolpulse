import 'package:dio/dio.dart';
import '../../domain/repository/scouting_repository.dart';
import '../../domain/model/prospecto_seguimiento.dart';
import '../../domain/model/reporte_scouting.dart';
import '../../domain/model/valoracion_economica.dart';
import '../remote/dto/prospecto_seguimiento_dto.dart';
import '../remote/dto/reporte_scouting_dto.dart';
import '../remote/dto/valoracion_economica_dto.dart';
import '../remote/dto/paginated_response_dto.dart';
import '../../core/error/api_exception.dart';
import '../../data/local/secure_storage.dart';

import '../remote/dto/metrica_tecnica_dto.dart';
import '../remote/dto/metrica_tactica_dto.dart';
import '../../domain/model/metrica_tecnica.dart';
import '../../domain/model/metrica_tactica.dart';

class ScoutingRepositoryImpl implements ScoutingRepository {
  final Dio _dio;
  final SecureStorage _storage = SecureStorage();

  ScoutingRepositoryImpl(this._dio);

  @override
  Future<List<ProspectoSeguimiento>> getProspectos() async {
    List<ProspectoSeguimientoDto> allResults = [];
    String? nextPath = '/prospectos-seguimiento/';

    while (nextPath != null) {
      final response = await _dio.get(nextPath);
      if (response.data is Map && response.data.containsKey('results')) {
        final paginated = PaginatedResponseDto<ProspectoSeguimientoDto>.fromJson(
            response.data, (json) => ProspectoSeguimientoDto.fromJson(json));
        allResults.addAll(paginated.results);
        if (paginated.next != null) {
          final uri = Uri.parse(paginated.next!);
          nextPath = '/prospectos-seguimiento/?${uri.query}';
        } else {
          nextPath = null;
        }
      } else if (response.data is List) {
        allResults.addAll((response.data as List).map((j) => ProspectoSeguimientoDto.fromJson(j)));
        nextPath = null;
      } else {
        nextPath = null;
      }
    }
    return allResults.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<ProspectoSeguimiento> createProspecto(Map<String, dynamic> data) async {
    final userData = await _storage.getUserData();
    data['usuario'] = userData['id'];
    try {
      final response = await _dio.post('/prospectos-seguimiento/', data: data);
      return ProspectoSeguimientoDto.fromJson(response.data).toDomain();
    } on DioException catch (e) {
      throw ApiException('Error al crear prospecto', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<ProspectoSeguimiento> updateProspecto(String id, Map<String, dynamic> data) async {
    final response = await _dio.patch('/prospectos-seguimiento/$id/', data: data);
    return ProspectoSeguimientoDto.fromJson(response.data).toDomain();
  }

  @override
  Future<void> deleteProspecto(String id) async => await _dio.delete('/prospectos-seguimiento/$id/');

  @override
  Future<List<ReporteScouting>> getReportes() async {
    List<ReporteScoutingDto> allResults = [];
    String? nextPath = '/reportes-scouting/';

    while (nextPath != null) {
      final response = await _dio.get(nextPath);
      if (response.data is Map && response.data.containsKey('results')) {
        final paginated = PaginatedResponseDto<ReporteScoutingDto>.fromJson(
            response.data, (json) => ReporteScoutingDto.fromJson(json));
        allResults.addAll(paginated.results);
        if (paginated.next != null) {
          final uri = Uri.parse(paginated.next!);
          nextPath = '/reportes-scouting/?${uri.query}';
        } else {
          nextPath = null;
        }
      } else if (response.data is List) {
        allResults.addAll((response.data as List).map((j) => ReporteScoutingDto.fromJson(j)));
        nextPath = null;
      } else {
        nextPath = null;
      }
    }
    return allResults.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<ReporteScouting> createReporte(Map<String, dynamic> data) async {
    final userData = await _storage.getUserData();
    final String? userId = userData['id'];
    
    if (userId == null || userId.isEmpty) {
      throw ApiException('ID de usuario no encontrado. Por favor, cierra sesión y vuelve a entrar.');
    }

    final payload = {
      'usuario': userId,
      'jugador': data['jugador'] ?? null,
      'prospecto': data['prospecto'] ?? null,
      'valoracion_estrellas': data['valoracion_estrellas'],
      'comentario_tecnico': data['comentario_tecnico'],
      'partido_observado': data['partido_observado'],
      'fecha_reporte': DateTime.now().toIso8601String().split('T')[0],
    };
    
    try {
      final response = await _dio.post('/reportes-scouting/', data: payload);
      return ReporteScoutingDto.fromJson(response.data).toDomain();
    } on DioException catch (e) {
      throw ApiException('Error API (${e.response?.statusCode}): ${e.response?.data}');
    }
  }

  @override
  Future<ReporteScouting> updateReporte(String id, Map<String, dynamic> data) async {
    final response = await _dio.patch('/reportes-scouting/$id/', data: data);
    return ReporteScoutingDto.fromJson(response.data).toDomain();
  }

  @override
  Future<void> deleteReporte(String id) async {
    await _dio.delete('/reportes-scouting/$id/');
  }

  @override
  Future<void> saveMetricasTecnicas(Map<String, dynamic> data) async {
    await _dio.post('/metricas-tecnicas/', data: data);
  }

  @override
  Future<void> saveMetricasTacticas(Map<String, dynamic> data) async {
    await _dio.post('/metricas-tacticas/', data: data);
  }

  @override
  Future<MetricaTecnica?> getMetricasTecnicas(String reporteId) async {
    try {
      String? nextPath = '/metricas-tecnicas/';
      
      while (nextPath != null) {
        final response = await _dio.get(nextPath);
        List<MetricaTecnicaDto> dtos = [];
        
        if (response.data is Map && response.data.containsKey('results')) {
          final paginated = PaginatedResponseDto<MetricaTecnicaDto>.fromJson(
              response.data, (json) => MetricaTecnicaDto.fromJson(json));
          dtos = paginated.results;
          
          final match = dtos.where((d) => d.reporteId == reporteId).firstOrNull;
          if (match != null) return match.toDomain();
          
          if (paginated.next != null) {
            final uri = Uri.parse(paginated.next!);
            nextPath = '/metricas-tecnicas/?${uri.query}';
          } else {
            nextPath = null;
          }
        } else if (response.data is List) {
          dtos = (response.data as List).map((json) => MetricaTecnicaDto.fromJson(json)).toList();
          final match = dtos.where((d) => d.reporteId == reporteId).firstOrNull;
          return match?.toDomain();
        } else {
          nextPath = null;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<MetricaTactica?> getMetricasTacticas(String reporteId) async {
    try {
      String? nextPath = '/metricas-tacticas/';
      
      while (nextPath != null) {
        final response = await _dio.get(nextPath);
        List<MetricaTacticaDto> dtos = [];
        
        if (response.data is Map && response.data.containsKey('results')) {
          final paginated = PaginatedResponseDto<MetricaTacticaDto>.fromJson(
              response.data, (json) => MetricaTacticaDto.fromJson(json));
          dtos = paginated.results;
          
          final match = dtos.where((d) => d.reporteId == reporteId).firstOrNull;
          if (match != null) return match.toDomain();
          
          if (paginated.next != null) {
            final uri = Uri.parse(paginated.next!);
            nextPath = '/metricas-tacticas/?${uri.query}';
          } else {
            nextPath = null;
          }
        } else if (response.data is List) {
          dtos = (response.data as List).map((json) => MetricaTacticaDto.fromJson(json)).toList();
          final match = dtos.where((d) => d.reporteId == reporteId).firstOrNull;
          return match?.toDomain();
        } else {
          nextPath = null;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ValoracionEconomica>> getValoraciones(String? jugadorId) async {
    List<ValoracionEconomicaDto> allDtos = [];
    String? nextPath = '/valoracion-economica/';
    
    while (nextPath != null) {
      final response = await _dio.get(nextPath);
      if (response.data is Map && response.data.containsKey('results')) {
        final paginated = PaginatedResponseDto<ValoracionEconomicaDto>.fromJson(
            response.data, (json) => ValoracionEconomicaDto.fromJson(json));
        allDtos.addAll(paginated.results);
        if (paginated.next != null) {
          final uri = Uri.parse(paginated.next!);
          nextPath = '/valoracion-economica/?${uri.query}';
        } else {
          nextPath = null;
        }
      } else if (response.data is List) {
        allDtos.addAll((response.data as List).map((j) => ValoracionEconomicaDto.fromJson(j)));
        nextPath = null;
      } else {
        nextPath = null;
      }
    }
    
    if (jugadorId != null) {
      return allDtos
          .where((dto) {
            final String? id = dto.jugador is String ? dto.jugador : dto.jugadorId;
            return id == jugadorId;
          })
          .map((dto) => dto.toDomain())
          .toList();
    }

    return allDtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> saveValoracion(Map<String, dynamic> data) async {
    try {
       await _dio.post('/valoracion-economica/', data: data);
    } on DioException catch (e) {
       throw ApiException('Error al tasar: ${e.response?.data}');
    }
  }

  @override
  Future<void> updateValoracion(String id, Map<String, dynamic> data) async {
    try {
      await _dio.patch('/valoracion-economica/$id/', data: data);
    } on DioException catch (e) {
      throw ApiException('Error al actualizar tasación: ${e.response?.data}');
    }
  }
}
