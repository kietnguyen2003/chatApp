import 'package:chat_app/layers/domain/entity/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cachedAccessTokenKey = 'cachedAccessTokenKey';
const cachedRefreshTokenKey = 'cachedRefreshTokenKey';
const cachedUserIdKey = 'cachedUserIdKey';

abstract class LocalStorage {
  Future<bool> saveToken(Auth auth);
  Future<String?> getAccessToken();
  Future<String?> getReFreshToken();
  Future<String?> getUserId();
  Future<bool> removeToken();
  Future<bool> saveConversationId(String conversationId);
  Future<String?> getConversationId();
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences _sharedPref;

  LocalStorageImpl({required SharedPreferences sharedPreferences})
    : _sharedPref = sharedPreferences;

  @override
  Future<bool> saveToken(Auth auth) async {
    try {
      final accessToken = auth.accessToken;
      final refreshToken = auth.refreshToken;
      final userId = auth.userId;
      if (accessToken == null ||
          accessToken.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty ||
          userId == null ||
          userId.isEmpty) {
        return false;
      }
      await _sharedPref.setString(cachedAccessTokenKey, accessToken);
      await _sharedPref.setString(cachedRefreshTokenKey, refreshToken);
      await _sharedPref.setString(cachedUserIdKey, userId);
      return true;
    } catch (e) {
      // Sử dụng logger thay vì print
      return false;
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return _sharedPref.getString(cachedAccessTokenKey);
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }

  @override
  Future<String?> getReFreshToken() async {
    try {
      return _sharedPref.getString(cachedRefreshTokenKey);
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      return _sharedPref.getString(cachedUserIdKey);
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }

  @override
  Future<bool> removeToken() async {
    try {
      await _sharedPref.remove(cachedAccessTokenKey);
      await _sharedPref.remove(cachedRefreshTokenKey);
      await _sharedPref.remove(cachedUserIdKey);
    } catch (e) {
      print('Error removing tokens: $e');
      return false;
    }
    return true;
  }

  @override
  Future<bool> saveConversationId(String conversationId) async {
    try {
      String? existingConversationId = _sharedPref.getString('conversationId');
      if (existingConversationId == null) {
        await _sharedPref.setString('conversationId', conversationId);
      }

      return true;
    } catch (e) {
      print('Error saving conversation ID: $e');
      return false;
    }
  }

  @override
  Future<String?> getConversationId() async {
    try {
      return _sharedPref.getString('conversationId');
    } catch (e) {
      print('Error retrieving conversation ID: $e');
      return null;
    }
  }
}
