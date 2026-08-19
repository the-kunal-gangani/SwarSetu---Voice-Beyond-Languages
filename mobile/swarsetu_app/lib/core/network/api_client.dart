import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'api_exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({DioClient? dioClient}) : _dio = (dioClient ?? DioClient()).dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> postFormData(
    String path, {
    required FormData formData,
  }) async {
    try {
      return await _dio.post(path, data: formData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          final message =
              e.response?.data is Map && e.response?.data['detail'] != null
              ? e.response!.data['detail'].toString()
              : 'Invalid request.';
          return BadRequestException(message, statusCode: statusCode);
        }
        return ServerException(statusCode: statusCode);
      default:
        return const NetworkException();
    }
  }
}
