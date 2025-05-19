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
  final Map<String, String> assistant;
  final String role;
  final String content;
  final List<String> files;

  const MessageRequest({
    required this.assistant,
    required this.role,
    required this.content,
    required this.files,
  });

  @override
  List<Object?> get props => [assistant, role, content, files];
  @override
  String toString() {
    return '{assistant: $assistant, role: $role, content: $content, files: $files}';
  }

  Map<String, dynamic> toJson() {
    return {
      'assistant': assistant,
      'role': role,
      'content': content,
      'files': files,
    };
  }
}

class HistoryItem with EquatableMixin {
  final String title;
  final String id;
  final String createdAt;

  const HistoryItem({
    required this.title,
    required this.id,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [title, id, createdAt];
  @override
  String toString() {
    return 'HistoryItem{title: $title, id: $id, createdAt: $createdAt}';
  }
}

class HistoryConversations with EquatableMixin {
  final bool hasMore;
  final List<HistoryItem> items;

  const HistoryConversations({required this.hasMore, required this.items});

  @override
  List<Object?> get props => [hasMore, items];
  @override
  String toString() {
    return 'HistoryConversations{hasMore: $hasMore, items: $items}';
  }
}
