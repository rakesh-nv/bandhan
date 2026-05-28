import 'package:get/get.dart';
import 'package:bandhan/models/chat_room_model.dart';
import 'package:bandhan/models/message_model.dart';
import 'package:bandhan/services/supabase_service.dart';

class ChatRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  Future<ChatRoomModel> createOrGetChatRoom(String matchId) async {
    // Check if exists
    final existing = await _supabaseService.client
        .from('chat_rooms')
        .select()
        .eq('match_id', matchId)
        .maybeSingle();

    if (existing != null) {
      return ChatRoomModel.fromJson(existing);
    }

    // Create new
    final response = await _supabaseService.client
        .from('chat_rooms')
        .insert({'match_id': matchId})
        .select()
        .single();
    return ChatRoomModel.fromJson(response);
  }

  Future<List<MessageModel>> getMessages(String chatRoomId, {int limit = 50, int offset = 0}) async {
    final response = await _supabaseService.client
        .from('messages')
        .select()
        .eq('chat_room_id', chatRoomId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
        
    return (response as List).map((e) => MessageModel.fromJson(e)).toList();
  }

  Future<MessageModel> sendMessage(MessageModel message) async {
    final response = await _supabaseService.client
        .from('messages')
        .insert({
          'chat_room_id': message.chatRoomId,
          'sender_id': message.senderId,
          'message': message.message,
          'is_read': false,
        })
        .select()
        .single();
    return MessageModel.fromJson(response);
  }

  Future<void> markMessagesAsRead(String chatRoomId, String otherUserId) async {
    await _supabaseService.client
        .from('messages')
        .update({'is_read': true})
        .eq('chat_room_id', chatRoomId)
        .eq('sender_id', otherUserId)
        .eq('is_read', false);
  }
}
