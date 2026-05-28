import 'dart:async';
import 'package:get/get.dart';

import '../../controllers/interest_controller.dart';
import '../../controllers/match_controller.dart';
import '../../models/chat_room_model.dart';
import '../../models/message_model.dart';
import '../../models/profile_model.dart';
import '../../repositories/chat_repository.dart';
import '../../repositories/profile_repository.dart';
import '../../services/auth_service.dart';

class ChatController extends GetxController {
  final ProfileRepository _profileRepo = Get.find<ProfileRepository>();
  final ChatRepository _chatRepo = Get.find<ChatRepository>();
  final AuthService _authService = Get.find<AuthService>();
  final MatchController _matchCtrl = Get.find<MatchController>();
  final InterestController _interestCtrl = Get.find<InterestController>();

  final RxList<ChatListItem> activeChats = <ChatListItem>[].obs;
  final RxList<MessageModel> currentChatMessages = <MessageModel>[].obs;
  final RxBool isTyping = false.obs;
  final RxString activeReceiverId = ''.obs;
  
  // Track active chat room
  ChatRoomModel? activeChatRoom;

  @override
  void onInit() {
    super.onInit();
    // Keep active chats updated when matches or interests change
    ever(_matchCtrl.matches, (_) => updateActiveChats());
    ever(_interestCtrl.acceptedInterests, (_) => updateActiveChats());
    updateActiveChats();
  }

  Future<void> updateActiveChats() async {
    if (_authService.currentUserId == null) return;
    
    // Active chats are matches
    await _matchCtrl.fetchMatches();
    
    final List<ChatListItem> items = [];
    
    for (var match in _matchCtrl.matches) {
      final String otherUserId = match.user1Id == _authService.currentUserId
          ? match.user2Id
          : match.user1Id;
          
      final otherProfile = await _profileRepo.getProfile(otherUserId);
      if (otherProfile == null) continue;
      
      final room = await _chatRepo.createOrGetChatRoom(match.id);
      
      final msgs = await _chatRepo.getMessages(room.id, limit: 1);
      final lastMessage = msgs.isNotEmpty ? msgs.first : null;
      
      // Count unread
      final allMsgs = await _chatRepo.getMessages(room.id, limit: 50);
      final unreadCount = allMsgs.where((m) => m.senderId == otherUserId && !m.isRead).length;
      
      items.add(ChatListItem(
        profile: otherProfile,
        lastMessage: lastMessage,
        unreadCount: unreadCount,
        isOnline: false,
      ));
    }
    
    // Sort
    items.sort((a, b) {
      if (a.lastMessage == null && b.lastMessage == null) return 0;
      if (a.lastMessage == null) return 1;
      if (b.lastMessage == null) return -1;
      return (b.lastMessage!.createdAt ?? DateTime.now())
          .compareTo(a.lastMessage!.createdAt ?? DateTime.now());
    });
    
    activeChats.assignAll(items);
  }

  Future<void> loadChatMessages(String receiverId) async {
    activeReceiverId.value = receiverId;
    if (_authService.currentUserId == null) return;
    
    // Find matching match
    final match = _matchCtrl.matches.firstWhereOrNull((m) =>
        (m.user1Id == _authService.currentUserId && m.user2Id == receiverId) ||
        (m.user2Id == _authService.currentUserId && m.user1Id == receiverId));
        
    if (match == null) return;
    
    final room = await _chatRepo.createOrGetChatRoom(match.id);
    activeChatRoom = room;
    
    await _chatRepo.markMessagesAsRead(room.id, receiverId);
    await _refreshMessageThread(room.id);
  }

  Future<void> _refreshMessageThread(String chatRoomId) async {
    final msgs = await _chatRepo.getMessages(chatRoomId);
    // Reverse to show oldest first in UI
    currentChatMessages.assignAll(msgs.reversed.toList());
    updateActiveChats();
  }

  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty || activeChatRoom == null || _authService.currentUserId == null) return;

    final msg = MessageModel(
      id: '',
      chatRoomId: activeChatRoom!.id,
      senderId: _authService.currentUserId!,
      message: text.trim(),
    );
    
    await _chatRepo.sendMessage(msg);
    await _refreshMessageThread(activeChatRoom!.id);
  }

  Future<void> sendMediaMessage(String mediaUrl) async {
    if (activeChatRoom == null || _authService.currentUserId == null) return;
    
    final msg = MessageModel(
      id: '',
      chatRoomId: activeChatRoom!.id,
      senderId: _authService.currentUserId!,
      message: '[Shared Image]',
    );
    
    await _chatRepo.sendMessage(msg);
    await _refreshMessageThread(activeChatRoom!.id);
  }

  Future<void> sendAudioMessage() async {
    if (activeChatRoom == null || _authService.currentUserId == null) return;

    final msg = MessageModel(
      id: '',
      chatRoomId: activeChatRoom!.id,
      senderId: _authService.currentUserId!,
      message: '[Shared Voice Message]',
    );
    
    await _chatRepo.sendMessage(msg);
    await _refreshMessageThread(activeChatRoom!.id);
  }
}

class ChatListItem {
  final ProfileModel profile;
  final MessageModel? lastMessage;
  final int unreadCount;
  final bool isOnline;

  ChatListItem({
    required this.profile,
    this.lastMessage,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}
