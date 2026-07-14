import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../local/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getAccessToken();
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        print('Dio: Error 401 en ${err.requestOptions.path}. Token inválido o expirado.');
      }
    }
    return handler.next(err);
  }
}
