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
}
