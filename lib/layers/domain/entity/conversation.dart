import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:equatable/equatable.dart';

class MessageResponse with EquatableMixin {
  final String conversationId;
  final String message;
  final int remainingUsage;

  const MessageResponse({
    required this.conversationId,
    required this.message,
    required this.remainingUsage,
  });

  @override
  List<Object?> get props => [conversationId, message, remainingUsage];
  @override
  String toString() {
    return 'MessageResponse{conversationId: $conversationId, message: $message, remainingUsage: $remainingUsage}';
  }
}

class MessageRequest with EquatableMixin {
  final String content;
  final List<String> file;
  final Map<String, dynamic> metadata;
  final Bot assistant;

  const MessageRequest({
    required this.content,
    required this.file,
    required this.metadata,
    required this.assistant,
  });

  @override
  List<Object?> get props => [content, file, metadata, assistant];
  @override
  String toString() {
    return 'MessageRequest{content: $content, file: $file, metadata: $metadata, assistant: $assistant}';
  }
}
