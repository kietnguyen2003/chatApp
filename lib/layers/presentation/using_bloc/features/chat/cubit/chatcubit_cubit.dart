import 'package:bloc/bloc.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';
import 'package:chat_app/layers/domain/usecase/conversation.dart';
import 'package:equatable/equatable.dart';

part 'chatcubit_state.dart';

class ChatcubitCubit extends Cubit<ChatcubitState> {
  // Biến instance để lưu danh sách tin nhắn
  List<Message> _messages = [];

  final Conversation conversationUseCase;
  ChatcubitCubit({required this.conversationUseCase})
    : super(ChatcubitInitial());

  Future<void> sendMessage(String message) async {
    emit(ChatcubitLoading());
    try {
      // Gọi API để gửi tin nhắn
      final response = await conversationUseCase.sendMessage(
        message,
        Bot(
          id: 'claude-3-haiku-20240307',
          model: 'dify',
          name: 'CLAUDE_3_HAIKU',
        ),
        _messages,
      );

      // Tạo tin nhắn bot
      final botResponse = Message(
        message: response.message,
        isUser: IsUser.bot,
        name: 'Bot',
      );

      // Thêm phản hồi bot vào danh sách
      _messages = [..._messages, botResponse];
      emit(ChatcubitMessage(_messages));
    } catch (e) {
      emit(ChatcubitError(e.toString()));
    }
  }

  // Hàm để khôi phục tin nhắn (nếu cần)
  void restoreMessages(List<Message> messages) {
    _messages = messages;
    emit(ChatcubitMessage(_messages));
  }

  // Hàm để reset danh sách tin nhắn (nếu cần)
  void resetMessages() {
    _messages = [];
    emit(ChatcubitInitial());
  }

  void changeBot(String botId) {
    emit(ChatcubitBotChanged(botId));
  }
}
