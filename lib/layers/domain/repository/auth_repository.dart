import 'package:chat_app/layers/domain/entity/auth.dart';

abstract class AuthRepository {
  Future<Auth> login(String email, String password);
}
