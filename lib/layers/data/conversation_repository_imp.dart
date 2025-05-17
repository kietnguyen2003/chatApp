import 'package:chat_app/constrance/api.dart';
import 'package:chat_app/layers/data/dto/conversation_dto.dart';
import 'package:chat_app/layers/data/source/local/local_storage.dart';
import 'package:chat_app/layers/data/source/network/api.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/conversation.dart';
import 'package:chat_app/layers/domain/repository/conversation_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationRepositoryImp extends ConversationRepository {
  final LocalStorage _localStorage;
  final Api _api;
  ConversationRepositoryImp({
    required Api api,
    required SharedPreferences sharedPreferences,
  }) : _api = api,
       _localStorage = LocalStorageImpl(sharedPreferences: sharedPreferences);
  @override
  Future<MessageResponse> sendMessage(String message, Bot bot) async {
    try {
      final accessToken = await _localStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }
      final response = await _api.post(
        ApiUrls.aiChat,
        {
          'content': message,
          'files': [], // Sửa từ 'file' thành 'files' để khớp API
          'metadata': {
            'conversation': {'messages': []},
          },
          'assistant': {'id': bot.id, 'name': bot.name, 'model': bot.model},
        },
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      print('Response from API: $response');
      final messageResponse = MessageResponseDTO.fromJson(response);
      if (messageResponse.message.isEmpty) {
        throw Exception('Response message cannot be empty');
      }

      return MessageResponse(
        conversationId: messageResponse.conversationId,
        message: messageResponse.message,
        remainingUsage: int.tryParse(messageResponse.remainingUsage) ?? 0,
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(
          'Failed to send message: ${e.response?.data['message'] ?? e.message}',
        );
      }
      throw Exception('Failed to send message: $e');
    }
  }
}
