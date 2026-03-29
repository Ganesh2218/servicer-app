class ChatMessageEntity {
  final String id;
  final String chatId; // Links the customer and provider responses
  final String senderId;
  final String content;
  final DateTime timestamp;

  ChatMessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });
}
