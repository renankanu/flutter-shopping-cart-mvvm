import 'package:dio/dio.dart';

import '../core.dart';

class DioClient {
  DioClient._();

  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            contentType: Headers.jsonContentType,
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            responseBody: true,
            requestBody: true,
          ),
        );

  static Dio get client => _dio;
}
