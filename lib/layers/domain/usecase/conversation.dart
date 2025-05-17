import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/conversation.dart';
import 'package:chat_app/layers/domain/repository/conversation_repository.dart';

class Conversation {
  final _conversationRepository;
  Conversation({required ConversationRepository conversationRepository})
    : _conversationRepository = conversationRepository;

  Future<MessageResponse> sendMessage(String message, Bot bot) async {
    if (message.isEmpty) {
      throw Exception('Message cannot be empty');
    }
    if (bot.id.isEmpty) {
      throw Exception('Bot ID cannot be empty');
    }
    MessageResponse response = await _conversationRepository.sendMessage(
      message,
      bot,
    );
    print('Response from use case: ${response.message}');
    if (response.message.isEmpty) {
      throw Exception('Response message cannot be empty');
    }
    return response;
  }
}
