import 'package:chat_app/layers/data/source/local/local_storage.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';
import 'package:chat_app/layers/domain/usecase/conversation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatChangeNotifer extends ChangeNotifier {
  final LocalStorage _localStorage;
  final Conversation _conversationUseCase;
  final List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ChatChangeNotifer({
    required Conversation conversationUseCase,
    required SharedPreferences sharedPreferences,
  }) : _conversationUseCase = conversationUseCase,
       _localStorage = LocalStorageImpl(sharedPreferences: sharedPreferences);

  Future<void> sendMessage(String message, Bot bot) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _messages.add(
        Message(message: message, isUser: IsUser.sender, name: "User"),
      );
      final response = await _conversationUseCase.sendMessage(message, bot);
      if (response != null) {
        print('Response at notifier: ${response.message}');
        _messages.add(
          Message(
            message: response.message,
            isUser: IsUser.bot,
            name: bot.name,
          ),
        );
      } else {
        _error = 'Failed to send message';
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          _error = 'Invalid token';
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

  Future<void> logout() async {
    try {
      await _localStorage.removeToken();
      _messages.clear();
      notifyListeners();
    } catch (e) {
      _error = 'Error logging out: $e';
      notifyListeners();
    }
  }
}
