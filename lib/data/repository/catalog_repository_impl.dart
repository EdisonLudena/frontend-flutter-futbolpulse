import 'package:dio/dio.dart';
import '../../domain/repository/catalog_repository.dart';
import '../../domain/model/entidad.dart';
import '../../domain/model/sede.dart';
import '../../domain/model/categoria.dart';
import '../../domain/model/posicion.dart';
import '../remote/dto/entidad_dto.dart';
import '../remote/dto/sede_dto.dart';
import '../remote/dto/categoria_dto.dart';
import '../remote/dto/posicion_dto.dart';
import '../remote/dto/paginated_response_dto.dart';
import '../../data/local/secure_storage.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final Dio _dio;
  final SecureStorage _storage = SecureStorage();

  CatalogRepositoryImpl(this._dio);

  @override
  Future<List<Entidad>> getEntidades() async {
    final response = await _dio.get('/entidades/');
    final paginated = PaginatedResponseDto<EntidadDto>.fromJson(response.data, (json) => EntidadDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> createEntidad(Map<String, dynamic> data) async {
    final user = await _storage.getUserData();
    data['usuario'] = user['id'];
    await _dio.post('/entidades/', data: data);
  }

  @override
  Future<void> updateEntidad(String id, Map<String, dynamic> data) async {
    await _dio.patch('/entidades/$id/', data: data);
  }

  @override
  Future<void> deleteEntidad(String id) async {
    await _dio.delete('/entidades/$id/');
  }

  @override
  Future<List<Categoria>> getCategorias({String? entidadId}) async {
    final response = await _dio.get('/categorias/', queryParameters: entidadId != null ? {'entidad': entidadId} : null);
    final paginated = PaginatedResponseDto<CategoriaDto>.fromJson(response.data, (json) => CategoriaDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> createCategoria(Map<String, dynamic> data) async {
    await _dio.post('/categorias/', data: data);
  }

  @override
  Future<void> updateCategoria(String id, Map<String, dynamic> data) async {
    await _dio.patch('/categorias/$id/', data: data);
  }

  @override
  Future<void> deleteCategoria(String id) async {
    await _dio.delete('/categorias/$id/');
  }

  @override
  Future<List<Sede>> getSedes({String? entidadId}) async {
    final response = await _dio.get('/sedes/', queryParameters: entidadId != null ? {'entidad': entidadId} : null);
    final paginated = PaginatedResponseDto<SedeDto>.fromJson(response.data, (json) => SedeDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> createSede(Map<String, dynamic> data) async {
    await _dio.post('/sedes/', data: data);
  }

  @override
  Future<void> updateSede(String id, Map<String, dynamic> data) async {
    await _dio.patch('/sedes/$id/', data: data);
  }

  @override
  Future<void> deleteSede(String id) async {
    await _dio.delete('/sedes/$id/');
  }

  @override
  Future<List<Posicion>> getPosiciones() async {
    final response = await _dio.get('/posiciones/');
    final paginated = PaginatedResponseDto<PosicionDto>.fromJson(response.data, (json) => PosicionDto.fromJson(json));
    return paginated.results.map((dto) => dto.toDomain()).toList();
  }
}
