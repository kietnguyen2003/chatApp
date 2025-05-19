import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/conversation.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';
import 'package:chat_app/layers/domain/repository/conversation_repository.dart';

class Conversation {
  final _conversationRepository;
  Conversation({required ConversationRepository conversationRepository})
    : _conversationRepository = conversationRepository;

  Future<MessageResponse> sendMessage(
    String message,
    Bot bot,
    List<Message> messages,
  ) async {
    if (message.isEmpty) {
      throw Exception('Message cannot be empty');
    }
    if (bot.id.isEmpty) {
      throw Exception('Bot ID cannot be empty');
    }
    print("Step 3: send message at use case: $message");
    MessageResponse response = await _conversationRepository.sendMessage(
      message,
      bot,
      messages,
    );
    print('Response from use case: ${response.message}');
    if (response.message.isEmpty) {
      throw Exception('Response message cannot be empty');
    }
    return response;
  }

  Future<HistoryConversations> getHistoryConversationss(
    String assistantId,
  ) async {
    if (assistantId.isEmpty) {
      throw Exception('Assistant ID cannot be empty');
    }
    print('Assistant ID: $assistantId at use case');
    HistoryConversations history = await _conversationRepository
        .getHistoryConversations(assistantId);
    if (history.items.isEmpty) {
      throw Exception('No conversations found');
    }
    return history;
  }
}
