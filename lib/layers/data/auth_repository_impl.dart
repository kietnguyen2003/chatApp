import 'package:chat_app/constrance/api.dart';
import 'package:chat_app/layers/data/dto/auth_dto.dart';
import 'package:chat_app/layers/data/source/network/api.dart';
import 'package:chat_app/layers/domain/entity/auth.dart';
import 'package:chat_app/layers/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Api _api;
  AuthRepositoryImpl({required Api api}) : _api = api;
  @override
  Future<Auth> login(String email, String password) async {
    final response = await _api.post(ApiUrls.login, {
      'email': email,
      'password': password,
    });
    print('Response: $response');
    final authDto = AuthDto.fromJson(response);
    return Auth(
      accessToken: authDto.token,
      refreshToken: authDto.refreshToken,
      userId: authDto.user,
    );
  }
}
