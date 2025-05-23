import 'package:chat_app/layers/domain/entity/auth.dart';
import 'package:chat_app/layers/domain/usecase/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthChangeNotifier extends ChangeNotifier {
  final Login _loginUseCase;

  AuthChangeNotifier({required Login loginUseCase})
    : _loginUseCase = loginUseCase;

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
