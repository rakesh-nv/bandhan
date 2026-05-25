import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/models.dart';
import '../../services/supabase_service.dart';

class ChatController extends GetxController {
  final SupabaseService dbService = Get.find<SupabaseService>();

  final RxList<ChatListItem> activeChats = <ChatListItem>[].obs;
  final RxList<Message> currentChatMessages = <Message>[].obs;
  final RxBool isTyping = false.obs;
  final RxString activeReceiverId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Watch messages and interests in dbService to keep active chats list updated in real-time
    ever(dbService.mockMessages, (_) => updateActiveChats());
    ever(dbService.mockInterests, (_) => updateActiveChats());
    updateActiveChats();
  }

  void updateActiveChats() {
    // Active chat users are those with accepted interest
    final acceptedInterests = dbService.mockInterests
        .where((i) =>
            (i.senderId == 'usr_curr' || i.receiverId == 'usr_curr') &&
            i.status == InterestStatus.accepted)
        .toList();

    final List<ChatListItem> items = [];

    for (var interest in acceptedInterests) {
      // Find the other user profile
      final String otherId = interest.senderId == 'usr_curr'
          ? interest.receiverId
          : interest.senderId;
      
      final otherProfile = dbService.mockProfiles.firstWhereOrNull((p) => p.id == otherId) ?? interest.otherProfile;

      // Get messages between current user and other user
      final chatMessages = dbService.mockMessages
          .where((m) =>
              (m.senderId == 'usr_curr' && m.receiverId == otherId) ||
              (m.senderId == otherId && m.receiverId == 'usr_curr'))
          .toList();

      chatMessages.sort((a, b) => a.sentAt.compareTo(b.sentAt));

      final lastMessage = chatMessages.isNotEmpty ? chatMessages.last : null;
      final unreadCount = chatMessages
          .where((m) => m.senderId == otherId && !m.isRead)
          .length;

      // Online status mock
      final bool isOnline = otherId == 'usr_2'; // Priyanka Patil is mock online
      
      items.add(ChatListItem(
        profile: otherProfile,
        lastMessage: lastMessage,
        unreadCount: unreadCount,
        isOnline: isOnline,
      ));
    }

    // Sort active chats by last message time
    items.sort((a, b) {
      if (a.lastMessage == null && b.lastMessage == null) return 0;
      if (a.lastMessage == null) return 1;
      if (b.lastMessage == null) return -1;
      return b.lastMessage!.sentAt.compareTo(a.lastMessage!.sentAt);
    });

    activeChats.assignAll(items);
  }

  void loadChatMessages(String receiverId) {
    activeReceiverId.value = receiverId;
    
    // Mark messages from this user as read
    for (int i = 0; i < dbService.mockMessages.length; i++) {
      final msg = dbService.mockMessages[i];
      if (msg.senderId == receiverId && msg.receiverId == 'usr_curr' && !msg.isRead) {
        dbService.mockMessages[i] = Message(
          id: msg.id,
          senderId: msg.senderId,
          receiverId: msg.receiverId,
          content: msg.content,
          sentAt: msg.sentAt,
          isRead: true,
          mediaUrl: msg.mediaUrl,
          isAudio: msg.isAudio,
        );
      }
    }

    _refreshMessageThread(receiverId);
  }

  void _refreshMessageThread(String receiverId) {
    final chatMessages = dbService.mockMessages
        .where((m) =>
            (m.senderId == 'usr_curr' && m.receiverId == receiverId) ||
            (m.senderId == receiverId && m.receiverId == 'usr_curr'))
        .toList();

    chatMessages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    currentChatMessages.assignAll(chatMessages);
    updateActiveChats();
  }

  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty || activeReceiverId.isEmpty) return;

    final receiverId = activeReceiverId.value;
    await dbService.sendMessage(receiverId, text.trim());
    _refreshMessageThread(receiverId);

    // Auto-simulate other party response
    _simulateResponse(receiverId, text);
  }

  Future<void> sendMediaMessage(String mediaUrl) async {
    if (activeReceiverId.isEmpty) return;
    
    final receiverId = activeReceiverId.value;
    await dbService.sendMessage(receiverId, '', media: mediaUrl);
    _refreshMessageThread(receiverId);
    
    _simulateResponse(receiverId, "[Shared an Image]");
  }

  Future<void> sendAudioMessage() async {
    if (activeReceiverId.isEmpty) return;

    final receiverId = activeReceiverId.value;
    await dbService.sendMessage(receiverId, '', isAudio: true);
    _refreshMessageThread(receiverId);

    _simulateResponse(receiverId, "[Voice message]");
  }

  void _simulateResponse(String senderId, String userMsg) {
    // Only simulate if they are online
    isTyping.value = true;

    Timer(const Duration(seconds: 2), () {
      isTyping.value = false;
      
      String response = "That's lovely to hear! Let's talk more details with our parents.";
      if (userMsg.toLowerCase().contains("hi") || userMsg.toLowerCase().contains("hello")) {
        response = "Hello! How is your week going?";
      } else if (userMsg.toLowerCase().contains("parent") || userMsg.toLowerCase().contains("family")) {
        response = "Yes, family opinions are very important to me. My father would love to speak to yours.";
      } else if (userMsg.toLowerCase().contains("job") || userMsg.toLowerCase().contains("career") || userMsg.toLowerCase().contains("software")) {
        response = "It sounds like you have a very promising career. I appreciate dedication to work.";
      }

      final mockResponse = Message(
        id: 'msg_sim_${DateTime.now().millisecondsSinceEpoch}',
        senderId: senderId,
        receiverId: 'usr_curr',
        content: response,
        sentAt: DateTime.now(),
        isRead: false,
      );

      dbService.mockMessages.add(mockResponse);
      if (activeReceiverId.value == senderId) {
        _refreshMessageThread(senderId);
      }
    });
  }
}

class ChatListItem {
  final UserProfile profile;
  final Message? lastMessage;
  final int unreadCount;
  final bool isOnline;

  ChatListItem({
    required this.profile,
    this.lastMessage,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}
