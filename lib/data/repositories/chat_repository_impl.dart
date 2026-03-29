import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ChatMessageEntity>> getChatStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessageModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<void> sendMessage(ChatMessageEntity message) async {
    final model = ChatMessageModel(
      id: '',
      chatId: message.chatId,
      senderId: message.senderId,
      content: message.content,
      timestamp: message.timestamp,
    );

    // Save message into the subcollection
    await _firestore
        .collection('chats')
        .doc(message.chatId)
        .collection('messages')
        .add(model.toJson());

    // Update parent chat document for "last message" snippet (optional but good practice)
    await _firestore.collection('chats').doc(message.chatId).set({
      'lastMessage': message.content,
      'lastTimestamp': Timestamp.fromDate(message.timestamp),
    }, SetOptions(merge: true));
  }
}
