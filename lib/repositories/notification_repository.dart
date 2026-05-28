import 'package:get/get.dart';
import 'package:bandhan/models/notification_model.dart';
import 'package:bandhan/services/supabase_service.dart';

class NotificationRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  Future<List<NotificationModel>> getNotifications(String userId, {int limit = 50, int offset = 0}) async {
    final response = await _supabaseService.client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
        
    return (response as List).map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _supabaseService.client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<NotificationModel> createNotification(String userId, String title, String body) async {
    final response = await _supabaseService.client
        .from('notifications')
        .insert({
          'user_id': userId,
          'title': title,
          'body': body,
        })
        .select()
        .single();
    return NotificationModel.fromJson(response);
  }
}
