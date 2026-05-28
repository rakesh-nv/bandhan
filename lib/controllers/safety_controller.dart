import 'package:get/get.dart';
import 'package:bandhan/models/report_model.dart';
import 'package:bandhan/repositories/safety_repository.dart';
import 'package:bandhan/services/auth_service.dart';

class SafetyController extends GetxController {
  final SafetyRepository _safetyRepo = Get.find<SafetyRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;

  Future<bool> blockUser(String blockedId) async {
    if (_authService.currentUserId == null) return false;
    
    isLoading.value = true;
    try {
      await _safetyRepo.blockUser(_authService.currentUserId!, blockedId);
      Get.snackbar('Success', 'User has been blocked and will not appear again.');
      // Ideally, trigger discover fetch again or remove from lists locally
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to block user');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> reportUser(String reportedUserId, String reason, String description) async {
    if (_authService.currentUserId == null) return false;
    
    isLoading.value = true;
    try {
      final report = ReportModel(
        id: '',
        reporterId: _authService.currentUserId!,
        reportedUserId: reportedUserId,
        reason: reason,
        description: description,
      );
      await _safetyRepo.reportUser(report);
      Get.snackbar('Success', 'Report submitted. Our team will review it shortly.');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit report');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
