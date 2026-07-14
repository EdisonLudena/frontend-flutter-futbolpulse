import 'package:dio/dio.dart';
import '../../domain/repository/subscription_repository.dart';
import '../../domain/model/suscripcion.dart';
import '../remote/dto/suscripcion_dto.dart';
import '../remote/dto/paginated_response_dto.dart';
import '../../core/error/api_exception.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final Dio _dio;
  SubscriptionRepositoryImpl(this._dio);

  @override
  Future<Suscripcion?> getActiveSubscription() async {
    try {
      final response = await _dio.get('/suscripciones/');
      
      // Manejamos la respuesta paginada de DRF
      final paginated = PaginatedResponseDto<SuscripcionDto>.fromJson(
        response.data,
        (json) => SuscripcionDto.fromJson(json),
      );

      if (paginated.results.isEmpty) return null;

      // Buscamos la primera suscripción que sea 'Activo'
      final active = paginated.results.firstWhere(
        (s) => s.estado == 'Activo',
        orElse: () => paginated.results.first,
      );

      return active.toDomain();
    } on DioException catch (e) {
      throw ApiException('Error al verificar suscripción', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> createSubscription(Map<String, dynamic> data) async {
    try {
      await _dio.post('/suscripciones/', data: data);
    } on DioException catch (e) {
      throw ApiException('Error al procesar suscripción', statusCode: e.response?.statusCode);
    }
  }
}
