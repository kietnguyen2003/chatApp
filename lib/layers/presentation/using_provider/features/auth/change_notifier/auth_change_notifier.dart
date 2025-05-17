import 'package:chat_app/layers/data/source/local/local_storage.dart';
import 'package:chat_app/layers/domain/entity/auth.dart';
import 'package:chat_app/layers/domain/usecase/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthChangeNotifier extends ChangeNotifier {
  final Login _loginUseCase;
  final LocalStorage _localStorage;

  AuthChangeNotifier({
    required Login loginUseCase,
    required SharedPreferences sharedPreferences,
  }) : _loginUseCase = loginUseCase,
       _localStorage = LocalStorageImpl(sharedPreferences: sharedPreferences);

  // State variables
  bool _isLoading = false;
  String? _error;
  Auth? _auth;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Auth? get auth => _auth;

  Future login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _auth = await _loginUseCase.login(email, password);
      if (_auth != null) {
        final isSaved = await _localStorage.saveToken(_auth!);
        if (!isSaved) {
          _error = 'Failed to save token';
        }
      } else {
        _error = 'Login failed: No auth data received';
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          _error = 'Invalid email or password';
        } else {
          _error = 'Network error: ${e.message}';
        }
      } else {
        _error = 'Unexpected error: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
