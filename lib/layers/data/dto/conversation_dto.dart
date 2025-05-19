import 'package:chat_app/layers/domain/entity/conversation.dart';

class MessageResponseDTO {
  String conversationId;
  String message;
  String remainingUsage;

  MessageResponseDTO({
    required this.conversationId,
    required this.message,
    required this.remainingUsage,
  });

  factory MessageResponseDTO.fromJson(Map<String, dynamic> json) {
    if (json['conversationId'] == null ||
        json['message'] == null ||
        json['remainingUsage'] == null) {
      throw Exception('Invalid message response');
    }
    return MessageResponseDTO(
      conversationId: json['conversationId'].toString(),
      message: json['message'].toString(),
      remainingUsage: json['remainingUsage'].toString(),
    );
  }

  MessageResponse toDomain() {
    return MessageResponse(
      conversationId: conversationId,
      message: message,
      remainingUsage: int.tryParse(remainingUsage) ?? 0,
    );
  }
}

class HistoryItemDTO {
  String title;
  String id;
  String createdAt;

  HistoryItemDTO({
    required this.title,
    required this.id,
    required this.createdAt,
  });

  factory HistoryItemDTO.fromJson(Map<String, dynamic> json) {
    if (json['title'] == null ||
        json['id'] == null ||
        json['createdAt'] == null) {
      throw Exception('Invalid history item');
    }
    return HistoryItemDTO(
      title: json['title'].toString(),
      id: json['id'].toString(),
      createdAt: json['createdAt'].toString(),
    );
  }

  HistoryItem toDomain() {
    return HistoryItem(title: title, id: id, createdAt: createdAt);
  }
}

class HistoryConversationsDTO {
  bool hasMore;
  List<HistoryItemDTO> items;

  HistoryConversationsDTO({required this.hasMore, required this.items});

  factory HistoryConversationsDTO.fromJson(Map<String, dynamic> json) {
    if (json['has_more'] == null || json['items'] == null) {
      throw Exception('Invalid history conversations');
    }
    return HistoryConversationsDTO(
      hasMore: json['has_more'] as bool,
      items:
          (json['items'] as List)
              .map((item) => HistoryItemDTO.fromJson(item))
              .toList(),
    );
  }

  HistoryConversations toDomain() {
    return HistoryConversations(
      hasMore: hasMore,
      items: items.map((item) => item.toDomain()).toList(),
    );
  }
}
