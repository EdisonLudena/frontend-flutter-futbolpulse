import 'package:dio/dio.dart';
import '../../domain/repository/health_repository.dart';
import '../../domain/model/test_rendimiento.dart';
import '../../domain/model/lesion_registro.dart';
import '../../domain/model/antecedentes_salud.dart';
import '../../domain/model/historial_antropometrico.dart';
import '../remote/dto/test_rendimiento_dto.dart';
import '../remote/dto/lesion_registro_dto.dart';
import '../remote/dto/antecedentes_salud_dto.dart';
import '../remote/dto/historial_antropometrico_dto.dart';
import '../remote/dto/paginated_response_dto.dart';
import '../../domain/model/sesion_rehabilitacion.dart';
import '../../domain/model/plan_alimenticio.dart';
import '../../core/error/api_exception.dart';
import 'package:flutter/foundation.dart';

class HealthRepositoryImpl implements HealthRepository {
  final Dio _dio;
  HealthRepositoryImpl(this._dio);

  @override
  Future<List<LesionRegistro>> getAllLesiones() async {
    final response = await _dio.get('/lesiones/');
    final paginated = PaginatedResponseDto<LesionRegistroDto>.fromJson(response.data, (json) => LesionRegistroDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<LesionRegistro>> getLesiones(String jugadorId) async {
    final response = await _dio.get('/lesiones/', queryParameters: {'jugador_id': jugadorId});
    final paginated = PaginatedResponseDto<LesionRegistroDto>.fromJson(response.data, (json) => LesionRegistroDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> saveLesion(Map<String, dynamic> data) async {
    if (data.containsKey('id')) {
      await _dio.patch('/lesiones/${data['id']}/', data: data);
    } else {
      await _dio.post('/lesiones/', data: data);
    }
  }

  @override
  Future<void> deleteLesion(String id) async => await _dio.delete('/lesiones/$id/');

  @override
  Future<List<TestRendimiento>> getAllTests() async {
    final response = await _dio.get('/rendimiento/');
    final paginated = PaginatedResponseDto<TestRendimientoDto>.fromJson(response.data, (json) => TestRendimientoDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<TestRendimiento>> getTestsRendimiento(String jugadorId) async {
    final response = await _dio.get('/rendimiento/', queryParameters: {'jugador_id': jugadorId});
    final paginated = PaginatedResponseDto<TestRendimientoDto>.fromJson(response.data, (json) => TestRendimientoDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> saveTestRendimiento(Map<String, dynamic> data) async => await _dio.post('/rendimiento/', data: data);

  @override
  Future<void> deleteTestRendimiento(String id) async => await _dio.delete('/rendimiento/$id/');

  @override
  Future<List<AntecedentesSalud>> getAllAntecedentes() async {
    final response = await _dio.get('/salud/');
    final paginated = PaginatedResponseDto<AntecedentesSaludDto>.fromJson(response.data, (json) => AntecedentesSaludDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<AntecedentesSalud?> getAntecedentes(String jugadorId) async {
    final response = await _dio.get('/salud/', queryParameters: {'jugador_id': jugadorId});
    final paginated = PaginatedResponseDto<AntecedentesSaludDto>.fromJson(response.data, (json) => AntecedentesSaludDto.fromJson(json));
    return paginated.results.isEmpty ? null : paginated.results.first.toDomain();
  }

  @override
  Future<void> saveAntecedentes(Map<String, dynamic> data) async {
    try {
      await _dio.post('/salud/', data: data);
    } on DioException catch (e) {
      throw ApiException('Error al guardar antecedentes: ${e.response?.data}');
    }
  }

  @override
  Future<List<HistorialAntropometrico>> getAllAntropometria() async {
    final response = await _dio.get('/antropometria/');
    final paginated = PaginatedResponseDto<HistorialAntropometricoDto>.fromJson(response.data, (json) => HistorialAntropometricoDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<HistorialAntropometrico>> getHistorialAntropometrico(String jugadorId) async {
    final response = await _dio.get('/antropometria/', queryParameters: {'jugador_id': jugadorId});
    final paginated = PaginatedResponseDto<HistorialAntropometricoDto>.fromJson(response.data, (json) => HistorialAntropometricoDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> saveAntropometria(Map<String, dynamic> data) async => await _dio.post('/antropometria/', data: data);

  @override Future<List<SesionRehabilitacion>> getRehabilitacion(String id) async => [];
  @override Future<void> saveRehabilitacion(Map<String, dynamic> d) async {}
  @override Future<List<PlanAlimenticio>> getPlanesAlimenticios(String id) async => [];
  @override Future<void> savePlanAlimenticio(Map<String, dynamic> d) async {}
}
