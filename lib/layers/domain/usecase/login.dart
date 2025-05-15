import 'package:chat_app/layers/domain/entity/auth.dart';
import 'package:chat_app/layers/domain/repository/auth_repository.dart';

class Login {
  Login({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<Auth> login(String email, String password) async {
    return await _authRepository.login(email, password);
  }
}
