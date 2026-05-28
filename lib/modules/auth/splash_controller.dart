import 'dart:async';
import 'package:get/get.dart';
import '../../routes/routes.dart';
import '../../services/auth_service.dart';
import '../../repositories/profile_repository.dart';
import '../../controllers/profile_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Timer(const Duration(seconds: 3), () async {
      try {
        final authService = Get.find<AuthService>();
        if (authService.isAuthenticated) {
          final userId = authService.currentUserId;
          if (userId != null) {
            final profileRepo = Get.find<ProfileRepository>();
            final profile = await profileRepo.getProfile(userId);
            
            if (profile != null) {
              // Pre-populate ProfileController to avoid redundant calls later
              final profileController = Get.find<ProfileController>();
              profileController.currentProfile.value = profile;
              Get.offAllNamed(AppRoutes.hub);
            } else {
              Get.offAllNamed(AppRoutes.profileCreation);
            }
          } else {
            Get.offAllNamed(AppRoutes.login);
          }
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
      } catch (e) {
        // Fallback to login in case of any database or auth check errors
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }
}
