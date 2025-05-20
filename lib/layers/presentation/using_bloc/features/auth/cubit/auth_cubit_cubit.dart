import 'package:bloc/bloc.dart';
import 'package:chat_app/layers/data/source/local/local_storage.dart';
import 'package:chat_app/layers/domain/entity/auth.dart';
import 'package:chat_app/layers/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_cubit_state.dart';

class AuthCubitCubit extends Cubit<AuthCubitState> {
  final AuthRepository _authRepository;
  final LocalStorage _localStorage;

  AuthCubitCubit({
    required AuthRepository authRepository,
    required SharedPreferences sharedPreferences,
  }) : _authRepository = authRepository,
       _localStorage = LocalStorageImpl(sharedPreferences: sharedPreferences),
       super(AuthCubitInitial());

  Auth? authResponse;

  Future<void> login(String username, String password) async {
    emit(AuthCubitLoading());
    try {
      final authResponse = await _authRepository.login(username, password);
      await _localStorage.saveToken(authResponse);
      emit(AuthCubitSuccess("Login successful"));
      emit(
        AuthCubitLoggedIn(
          authResponse.accessToken ?? '',
          authResponse.refreshToken ?? '',
        ),
      );
    } catch (e) {
      emit(AuthCubitError(e.toString()));
    }
  }
}
