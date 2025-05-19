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
    MessageResponse response = await _conversationRepository.sendMessage(
      message,
      bot,
      messages,
    );
    if (response.message.isEmpty) {
      throw Exception('Response message cannot be empty');
    }
    return response;
  }

  Future<HistoryConversations> getConversationList(String assistantId) async {
    if (assistantId.isEmpty) {
      throw Exception('Assistant ID cannot be empty');
    }
    HistoryConversations history = await _conversationRepository
        .getHistoryConversations(assistantId);
    if (history.items.isEmpty) {
      throw Exception('No conversations found');
    }
    return history;
  }
}
