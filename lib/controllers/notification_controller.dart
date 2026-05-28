import 'package:get/get.dart';
import 'package:bandhan/models/notification_model.dart';
import 'package:bandhan/repositories/notification_repository.dart';
import 'package:bandhan/services/auth_service.dart';

class NotificationController extends GetxController {
  final NotificationRepository _notifRepo = Get.find<NotificationRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (_authService.currentUserId != null) {
      fetchNotifications();
    }
  }

  Future<void> fetchNotifications() async {
    if (_authService.currentUserId == null) return;
    
    isLoading.value = true;
    try {
      final list = await _notifRepo.getNotifications(_authService.currentUserId!);
      notifications.value = list;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch notifications');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _notifRepo.markAsRead(id);
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final notif = notifications[index];
        notifications[index] = notif.copyWith(isRead: true);
      }
    } catch (e) {
      print('Error marking notification as read: \$e');
    }
  }
}
