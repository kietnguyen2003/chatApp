import 'package:dio/dio.dart';

abstract class Api {
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
  });
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
    final response = await _dio.post(url, data: body);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(
        'Failed to load data: ${response.statusCode} ${response.data['message'] ?? ''}',
      );
    }
  }
}
