import 'package:get/get.dart';
import 'package:bandhan/services/realtime_service.dart';
import 'package:bandhan/services/auth_service.dart';

class NotificationService extends GetxService {
  final RealtimeService _realtimeService = Get.find<RealtimeService>();
  final AuthService _authService = Get.find<AuthService>();

  Future<NotificationService> init() async {
    // Listen to auth changes to start/stop listening to notifications
    ever(_authService.currentUser, (user) {
      if (user != null) {
        _realtimeService.subscribeToNotifications(user.id, _handleNewNotification);
      } else {
        _realtimeService.unsubscribeFromNotifications();
      }
    });
    
    return this;
  }

  void _handleNewNotification(Map<String, dynamic> payload) {
    // In a real app, you would use flutter_local_notifications to show a heads-up notification.
    final title = payload['title'] ?? 'New Notification';
    final body = payload['body'] ?? '';
    
    if (Get.isSnackbarOpen != true) {
      Get.snackbar(
        title,
        body,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    }
  }
}
