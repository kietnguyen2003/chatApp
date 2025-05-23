import 'package:dio/dio.dart';

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

abstract class Api {
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  });

  Future<Map<String, dynamic>> get(String url, {Map<String, dynamic>? headers});
}

class ApiImpl implements Api {
  final Dio _dio;
  ApiImpl({String? projectId, String? clientKey}) : _dio = Dio() {
    _dio.options.headers = {
      'X-Stack-Access-Type': 'client',
      'X-Stack-Project-Id': projectId ?? 'a914f06b-5e46-4966-8693-80e4b9f4f409',
      'X-Stack-Publishable-Client-Key':
          clientKey ?? 'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = Duration(seconds: 30);
    _dio.options.receiveTimeout = Duration(seconds: 30);
  }

  @override
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  }) async {
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
    try {
      final response = await _dio.post(url, data: body);
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
          response.data['message'] ?? 'Unauthorized: Invalid or expired token',
        );
      } else {
        throw Exception(
          'Failed to load data: ${response.statusCode} ${response.data['message'] ?? ''}',
        );
      }
    } catch (e) {
      if (e is UnauthorizedException) {
        throw e; // Truyền lỗi Unauthorized lên trên
      }
      if (e is DioException && e.response != null) {
        print(
          'DioException details: ${e.response?.data}, ${e.response?.statusCode}',
        );
        if (e.response?.statusCode == 401) {
          throw UnauthorizedException(
            e.response?.data['message'] ??
                'Unauthorized: Invalid or expired token',
          );
        }
        throw Exception(
          'Failed to send message: ${e.response?.data['message'] ?? e.message}',
        );
      }
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, dynamic>? headers,
  }) async {
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(
        response.data['message'] ?? 'Unauthorized: Invalid or expired token',
      );
    } else {
      throw Exception(
        'Failed to load data: ${response.statusCode} ${response.data['message'] ?? ''}',
      );
    }
  }
}
