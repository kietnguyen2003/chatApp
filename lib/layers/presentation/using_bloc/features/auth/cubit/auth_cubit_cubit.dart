import 'package:bloc/bloc.dart';
import 'package:chat_app/layers/domain/entity/auth.dart';
import 'package:chat_app/layers/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_cubit_state.dart';

class AuthCubitCubit extends Cubit<AuthCubitState> {
  final AuthRepository _authRepository;
  Auth? authResponse;

  AuthCubitCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthCubitInitial());

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      emit(AuthCubitError("Username or password cannot be empty"));
      return;
    }
    emit(AuthCubitLoading());
    try {
      authResponse = await _authRepository.login(username, password);
      emit(AuthCubitLoggedIn(authResponse!));
    } catch (e) {
      emit(AuthCubitError(e.toString()));
    }
  }

  Future<void> logout() async {
    authResponse = null;
    emit(AuthCubitLoggedIn(authResponse!));
  }
}
