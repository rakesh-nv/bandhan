import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bandhan/services/supabase_service.dart';

class RealtimeService extends GetxService {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  
  late final RealtimeChannel _messagesChannel;
  late final RealtimeChannel _notificationsChannel;

  Future<RealtimeService> init() async {
    // We will initialize channels specifically when a user logs in
    return this;
  }

  void subscribeToMessages(String userId, Function(Map<String, dynamic>) onNewMessage) {
    _messagesChannel = _supabaseService.client.channel('public:messages:$userId');
    
    _messagesChannel.onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'messages',
        // In a real app, you might filter by chat_room_id.
        // For simplicity, we just listen to all inserts and the UI will filter them
        callback: (payload) {
          onNewMessage(payload.newRecord);
        }).subscribe();
  }

  void unsubscribeFromMessages() {
    _supabaseService.client.removeChannel(_messagesChannel);
  }

  void subscribeToNotifications(String userId, Function(Map<String, dynamic>) onNewNotification) {
    _notificationsChannel = _supabaseService.client.channel('public:notifications:$userId');
    
    _notificationsChannel.onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'notifications',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: userId,
        ),
        callback: (payload) {
          onNewNotification(payload.newRecord);
        }).subscribe();
  }
  
  void unsubscribeFromNotifications() {
    _supabaseService.client.removeChannel(_notificationsChannel);
  }
}
