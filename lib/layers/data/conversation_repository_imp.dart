import 'package:chat_app/constrance/api.dart';
import 'package:chat_app/layers/data/dto/conversation_dto.dart' as dto;
import 'package:chat_app/layers/data/source/local/local_storage.dart';
import 'package:chat_app/layers/data/source/network/api.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/conversation.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';
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
  Future<MessageResponse> sendMessage(
    String message,
    Bot bot,
    List<Message> messages,
  ) async {
    try {
      final List<MessageRequest> messageRequests;
      String? conversationId = await _localStorage.getConversationId();
      if (conversationId == null) {
        throw Exception('No conversation ID found');
      }
      if (messages.isNotEmpty) {
        messageRequests =
            messages
                .map(
                  (message) => MessageRequest(
                    assistant: {'id': bot.id, 'model': bot.model},
                    role: message.isUser == IsUser.sender ? 'user' : 'model',
                    content: message.message,
                    files: [],
                  ),
                )
                .toList();
      } else {
        messageRequests = [];
      }
      final accessToken = await _localStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }
      messages.add(
        Message(message: message, isUser: IsUser.sender, name: "User"),
      );
      try {
        final response = await _api.post(
          ApiUrls.aiChat,
          {
            'content': message,
            'files': [],
            'metadata': {
              'conversation': {
                'messages': messageRequests.map((e) => e.toJson()).toList(),
                'id': conversationId,
              },
            },
            'assistant': {'id': bot.id, 'name': bot.name, 'model': bot.model},
          },
          headers: {
            'Authorization': 'Bearer $accessToken',
            'x-jarvis-guid': '',
          },
        );
        final messageResponse = dto.MessageResponseDTO.fromJson(response);
        if (messageResponse.message.isEmpty) {
          throw Exception('Response message cannot be empty');
        }
        bool isSuccess = await _localStorage.saveConversationId(
          messageResponse.conversationId,
        );
        if (!isSuccess) {
          throw Exception('Failed to save conversation ID');
        }
        return messageResponse.toDomain();
      } catch (e) {
        if (e is DioException && e.response != null) {
          throw Exception(
            'Failed to send message: ${e.response?.data['message'] ?? e.message}',
          );
        }
        throw Exception('Failed to send message: $e');
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(
          'Failed to send message: ${e.response?.data['message'] ?? e.message}',
        );
      }
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<HistoryConversations> getHistoryConversations(
    String assistantId,
  ) async {
    try {
      final accessToken = await _localStorage.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }
      final response = await _api.get(
        '${ApiUrls.aiChatHistory}?assistantId=$assistantId&assistantModel=dify',
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      final historyConversationsDTO = dto.HistoryConversationsDTO.fromJson(
        response,
      );
      final historyConversations = historyConversationsDTO.toDomain();
      return historyConversations;
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(
          'Failed to get history conversations: ${e.response?.data['message'] ?? e.message}',
        );
      }
      throw Exception('Failed to get history conversations: $e');
    }
  }
}
