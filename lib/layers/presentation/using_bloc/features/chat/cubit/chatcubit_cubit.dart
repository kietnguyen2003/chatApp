import 'package:bloc/bloc.dart';
import 'package:chat_app/layers/data/source/local/botList.dart';
import 'package:chat_app/layers/data/source/network/api.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/conversation.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';
import 'package:chat_app/layers/domain/usecase/conversation.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'chatcubit_state.dart';

class ChatCubit extends Cubit<ChatState> {
  // Biến instance để lưu danh sách tin nhắn
  List<Message> _messages = [];

  final Conversation conversationUseCase;
  ChatCubit({required this.conversationUseCase}) : super(ChatInitial());

  Future<void> sendMessage(
    String message,
    String botId,
    String accessToken,
    String? currentConversationId,
  ) async {
    emit(ChatLoading());
    try {
      Bot bot = Botlist.bots.firstWhere((bot) => bot.id == botId);
      final response = await conversationUseCase.sendMessage(
        message,
        bot,
        _messages,
        accessToken,
        currentConversationId,
      );

      final botResponse = Message(
        message: response.message,
        isUser: IsUser.bot,
        name: 'Bot',
      );
      _messages = [..._messages, botResponse];
      emit(
        ChatMessage(
          _messages,
          conversationId: response.conversationId,
          usageToken: response.remainingUsage,
        ),
      );
    } catch (e) {
      if (e is UnauthorizedException) {
        emit(ChatUnauthorized(e.message));
      } else if (e is DioException) {
        emit(ChatError(e.message ?? 'Dio error'));
      } else {
        emit(ChatError(e.toString()));
      }
    }
  }

  Future<HistoryConversations> getConversationList(
    String assistantId,
    String accessToken,
  ) async {
    try {
      final history = await conversationUseCase.getConversationList(
        assistantId,
        accessToken,
      );
      if (history.items.isEmpty) {
        emit(ChatError('No conversations found'));
        return history;
      }
      return history;
    } catch (e) {
      if (e is UnauthorizedException) {
        emit(ChatUnauthorized(e.message));
      } else if (e is DioException) {
        emit(ChatError(e.message ?? 'Dio error'));
      } else {
        emit(ChatError(e.toString()));
      }
      rethrow;
    }
  }

  // Hàm để reset danh sách tin nhắn (nếu cần)
  void resetMessages() {
    _messages = [];
    emit(ChatInitial());
  }

  void changeBot(String botId) {
    emit(ChatBotChanged(botId));
  }

  void newConversation() {
    _messages = [];
    emit(
      ChatMessage(
        _messages,
        conversationId: null,
        usageToken: 30, // Giá trị mặc định khi tạo mới
      ),
    );
  }
}
