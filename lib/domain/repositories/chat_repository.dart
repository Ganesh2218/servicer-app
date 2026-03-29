import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatMessageEntity>> getChatStream(String chatId);
  Future<void> sendMessage(ChatMessageEntity message);
}
