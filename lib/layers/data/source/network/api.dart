import 'package:dio/dio.dart';

abstract class Api {
  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body);
}

class ApiImpl implements Api {
  final Dio _dio;
  ApiImpl() : _dio = Dio() {
    _dio.options.headers = {
      'X-Stack-Access-Type': 'client',
      'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
      'X-Stack-Publishable-Client-Key':
          'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post(url, data: body);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
