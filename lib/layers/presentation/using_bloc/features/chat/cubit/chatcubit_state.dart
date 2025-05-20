part of 'chatcubit_cubit.dart';

sealed class ChatcubitState extends Equatable {
  const ChatcubitState();

  @override
  List<Object> get props => [];
}

final class ChatcubitInitial extends ChatcubitState {}

final class ChatcubitLoading extends ChatcubitState {}

final class ChatcubitSuccess extends ChatcubitState {
  final String messages;

  const ChatcubitSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

final class ChatcubitError extends ChatcubitState {
  final String error;

  const ChatcubitError(this.error);

  @override
  List<Object> get props => [error];
}

final class ChatcubitMessage extends ChatcubitState {
  final List<Message> message;

  const ChatcubitMessage(this.message);

  @override
  List<Object> get props => [message];
}

final class ChatcubitBotChanged extends ChatcubitState {
  final String botId;

  const ChatcubitBotChanged(this.botId);

  @override
  List<Object> get props => [botId];
}
