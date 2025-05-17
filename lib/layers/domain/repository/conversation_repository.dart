import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/conversation.dart';

abstract class ConversationRepository {
  Future<MessageResponse> sendMessage(String message, Bot bot);
}
