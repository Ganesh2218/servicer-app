import 'package:get/get.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../core/utils/shared_pref.dart';
import '../../core/utils/app_snackbar.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepository;

  ChatController(this._chatRepository);

  final RxList<ChatMessageEntity> messages = <ChatMessageEntity>[].obs;
  final RxBool isLoading = false.obs;

  String? currentChatId;

  // Binding stream to local observer
  void listenToChat(String chatId) {
    currentChatId = chatId;
    messages.bindStream(_chatRepository.getChatStream(chatId));
  }

  Future<void> sendMessage(String content) async {
    final senderId = SharedPrefs.getUserId();
    if (senderId == null || currentChatId == null || content.trim().isEmpty) return;

    final message = ChatMessageEntity(
      id: '',
      chatId: currentChatId!,
      senderId: senderId,
      content: content.trim(),
      timestamp: DateTime.now(),
    );

    try {
      await _chatRepository.sendMessage(message);
    } catch (e) {
      AppSnackbar.showError('Something went wrong. Please try again.');
    }
  }
}
