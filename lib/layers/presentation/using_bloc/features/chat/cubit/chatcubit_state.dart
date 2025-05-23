part of 'chatcubit_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatcubitInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatcubitSuccess extends ChatState {
  final String messages;

  const ChatcubitSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

final class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  @override
  List<Object> get props => [error];
}

final class ChatMessage extends ChatState {
  final List<Message> message;

  const ChatMessage(this.message);

  @override
  List<Object> get props => [message];
}

final class ChatBotChanged extends ChatState {
  final String botId;

  const ChatBotChanged(this.botId);

  @override
  List<Object> get props => [botId];
}

final class ChatUnauthorized extends ChatState {
  final String message;

  const ChatUnauthorized(this.message);

  @override
  List<Object> get props => [message];
}

final class ChatConversationId extends ChatState {
  final String currentId;
  final int usageToken;

  const ChatConversationId(this.currentId, this.usageToken);

  @override
  List<Object> get props => [currentId, usageToken];
}
