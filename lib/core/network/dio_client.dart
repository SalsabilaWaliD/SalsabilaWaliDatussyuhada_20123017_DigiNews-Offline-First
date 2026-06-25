import 'package:dio/dio.dart';
import '../utils/constants.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.newsApiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(LoggingInterceptor());
    dio.interceptors.add(ErrorInterceptor());

    return dio;
  }
}

/// Interceptor untuk mencatat semua request dan response
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('[DIO REQUEST] ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[DIO RESPONSE] ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('[DIO ERROR] ${err.type} - ${err.message}');
    handler.next(err);
  }
}

/// Interceptor untuk menangani error jaringan
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        handler.next(
          DioException(
            requestOptions: err.requestOptions,
            error: NetworkException('Connection timeout. Loading cache...'),
            type: err.type,
          ),
        );
        break;
      case DioExceptionType.connectionError:
        handler.next(
          DioException(
            requestOptions: err.requestOptions,
            error: NetworkException('No internet. Loading cached data...'),
            type: err.type,
          ),
        );
        break;
      default:
        handler.next(err);
    }
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}
