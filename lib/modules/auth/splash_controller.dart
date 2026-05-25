import 'dart:async';
import 'package:get/get.dart';
import '../../routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.login);
    });
  }
}
