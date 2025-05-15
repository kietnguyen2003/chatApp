import 'package:chat_app/layers/data/source/local/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatChangeNotifer extends ChangeNotifier {
  final LocalStorage _localStorage;
  ChatChangeNotifer({required SharedPreferences sharedPreferences})
    : _localStorage = LocalStorageImpl(sharedPreferences: sharedPreferences);

  Future<void> logout() async {
    try {
      await _localStorage.removeToken();
      notifyListeners();
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
