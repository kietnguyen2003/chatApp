import 'package:chat_app/constrance/api.dart';
import 'package:chat_app/layers/data/dto/auth_dto.dart';
import 'package:chat_app/layers/data/source/network/api.dart';
import 'package:chat_app/layers/domain/entity/auth.dart';
import 'package:chat_app/layers/domain/repository/auth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Api _api;
  AuthRepositoryImpl({required Api api}) : _api = api;
  @override
  Future<Auth> login(String email, String password) async {
    try {
      final response = await _api.post(ApiUrls.login, {
        'email': email,
        'password': password,
      });
      final authDto = AuthDto.fromJson(response);
      return Auth(
        accessToken: authDto.token,
        refreshToken: authDto.refreshToken,
        userId: authDto.user,
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(
          'Login failed: ${e.response?.data['message'] ?? e.message}',
        );
      }
      throw Exception('Login failed: $e');
    }
  }
}
