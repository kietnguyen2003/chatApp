import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/conversation.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';

abstract class ConversationRepository {
  Future<MessageResponse> sendMessage(
    String message,
    Bot bot,
    List<Message> messages,
  );
  Future<HistoryConversations> getHistoryConversations(String assistantId);
}
