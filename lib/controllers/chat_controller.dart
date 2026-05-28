import 'package:get/get.dart';
import 'package:bandhan/models/chat_room_model.dart';
import 'package:bandhan/models/message_model.dart';
import 'package:bandhan/repositories/chat_repository.dart';
import 'package:bandhan/services/auth_service.dart';
import 'package:bandhan/services/realtime_service.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepo = Get.find<ChatRepository>();
  final AuthService _authService = Get.find<AuthService>();
  final RealtimeService _realtimeService = Get.find<RealtimeService>();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final Rx<ChatRoomModel?> currentChatRoom = Rx<ChatRoomModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _subscribeToMessages();
  }

  void _subscribeToMessages() {
    if (_authService.currentUserId != null) {
      _realtimeService.subscribeToMessages(_authService.currentUserId!, (payload) {
        final newMessage = MessageModel.fromJson(payload);
        // If it belongs to the active chat room, add it to the list
        if (currentChatRoom.value != null && newMessage.chatRoomId == currentChatRoom.value!.id) {
           // Insert at beginning because list is often reversed in UI
           messages.insert(0, newMessage);
           _chatRepo.markMessagesAsRead(currentChatRoom.value!.id, newMessage.senderId);
        }
      });
    }
  }

  Future<void> openChatRoom(String matchId, String otherUserId) async {
    isLoading.value = true;
    messages.clear();
    try {
      final room = await _chatRepo.createOrGetChatRoom(matchId);
      currentChatRoom.value = room;
      
      final msgs = await _chatRepo.getMessages(room.id);
      messages.value = msgs;
      
      // Mark as read
      await _chatRepo.markMessagesAsRead(room.id, otherUserId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chat');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String text) async {
    if (currentChatRoom.value == null || _authService.currentUserId == null || text.trim().isEmpty) return;

    final msg = MessageModel(
      id: '', // Will be assigned by DB
      chatRoomId: currentChatRoom.value!.id,
      senderId: _authService.currentUserId!,
      message: text.trim(),
    );

    try {
      final newMsg = await _chatRepo.sendMessage(msg);
      // We don't necessarily need to add it here if realtime sends it back, 
      // but optimistic update makes it faster:
      messages.insert(0, newMsg);
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    }
  }
}
