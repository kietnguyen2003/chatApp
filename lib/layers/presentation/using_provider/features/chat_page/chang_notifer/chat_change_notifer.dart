import 'package:chat_app/layers/data/source/local/local_storage.dart';
import 'package:chat_app/layers/data/source/network/api.dart';
import 'package:chat_app/layers/domain/entity/auth.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/conversation.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';
import 'package:chat_app/layers/domain/usecase/conversation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatChangeNotifer extends ChangeNotifier {
  final LocalStorage _localStorage;
  final Conversation _conversationUseCase;
  final List<Message> _messages = [];
  String? _currentConversationId;
  HistoryConversations _historyConversations = HistoryConversations(
    items: [],
    hasMore: false,
  );
  bool _isLoading = false;
  String? _error;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  HistoryConversations get historyConversations => _historyConversations;
  String? get currentConversationId => _currentConversationId;

  ChatChangeNotifer({
    required Conversation conversationUseCase,
    required SharedPreferences sharedPreferences,
  }) : _conversationUseCase = conversationUseCase,
       _localStorage = LocalStorageImpl(sharedPreferences: sharedPreferences);

  Future<void> sendMessage(String message, Bot bot, String accessToken) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _conversationUseCase.sendMessage(
        message,
        bot,
        _messages,
        accessToken,
        _currentConversationId,
      );
      if (response.message.isNotEmpty) {
        _messages.add(
          Message(
            message: response.message,
            isUser: IsUser.bot,
            name: bot.name,
          ),
        );
      } else {
        _error = 'Empty response message';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e is UnauthorizedException) {
        print('UnauthorizedException: ${e.message}');
        _error = 'Unauthorized: ${e.message}';
      }
      if (e is DioException) {
        print(
          'DioException details: ${e.response?.data}, ${e.response?.statusCode}',
        );
        if (e.response?.statusCode == 401) {
          _error = 'Invalid token';
        } else {
          _error = 'Network error: ${e.response?.data ?? e.message}';
        }
      } else {
        _error = 'Unexpected error: $e';
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHistoryConversations(String assistantId) async {
    _isLoading = true;
    try {
      final response = await _conversationUseCase.getConversationList(
        assistantId,
      );
      _isLoading = false;
      _historyConversations = response;
    } catch (e) {
      _error = 'Error fetching history: $e';
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
