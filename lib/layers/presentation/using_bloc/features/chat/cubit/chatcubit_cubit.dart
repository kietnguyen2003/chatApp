import 'package:bloc/bloc.dart';
import 'package:chat_app/layers/data/source/local/botList.dart';
import 'package:chat_app/layers/data/source/network/api.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';
import 'package:chat_app/layers/domain/usecase/conversation.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'chatcubit_state.dart';

class ChatCubit extends Cubit<ChatState> {
  // Biến instance để lưu danh sách tin nhắn
  List<Message> _messages = [];

  final Conversation conversationUseCase;
  ChatCubit({required this.conversationUseCase}) : super(ChatcubitInitial());

  Future<void> sendMessage(
    String message,
    String botId,
    String accessToken,
    String? currentConversationId,
  ) async {
    emit(ChatLoading());
    try {
      // Gọi API để gửi tin nhắn
      Bot bot = Botlist.bots.firstWhere((bot) => bot.id == botId);
      final response = await conversationUseCase.sendMessage(
        message,
        bot,
        _messages,
        accessToken,
        currentConversationId,
      );

      // Tạo tin nhắn bot
      final botResponse = Message(
        message: response.message,
        isUser: IsUser.bot,
        name: 'Bot',
      );
      emit(
        ChatConversationId(response.conversationId, response.remainingUsage),
      );
      // Thêm phản hồi bot vào danh sách
      _messages = [..._messages, botResponse];
      emit(ChatMessage(_messages));
    } catch (e) {
      if (e is UnauthorizedException) {
        emit(ChatUnauthorized(e.message));
      } else if (e is DioException) {
        emit(ChatError(e.message ?? 'Dio error'));
      } else {
        emit(ChatError(e.toString()));
      }
      emit(ChatError(e.toString()));
    }
  }

  // Hàm để khôi phục tin nhắn (nếu cần)
  void restoreMessages(List<Message> messages) {
    _messages = messages;
    emit(ChatMessage(_messages));
  }

  // Hàm để reset danh sách tin nhắn (nếu cần)
  void resetMessages() {
    _messages = [];
    emit(ChatcubitInitial());
  }

  void changeBot(String botId) {
    emit(ChatBotChanged(botId));
  }
}
