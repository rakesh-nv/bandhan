import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/routes.dart';
import '../../services/supabase_service.dart';

class AuthController extends GetxController {
  final SupabaseService _dbService = Get.find<SupabaseService>();


  // Onboarding Screen logic
  final RxInt onboardingPage = 0.obs;
  final PageController onboardingController = PageController();
  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Find Your Perfect Match',
      'subtitle': 'Discover trusted profiles verified within your community. Your journey to a lifelong partner starts here.',
    },
    {
      'title': 'Trusted Community Focus',
      'subtitle': 'We connect hearts within small, close-knit communities where everyone is verified by trusted members.',
    },
    {
      'title': 'Secure & Private Conversations',
      'subtitle': 'Photos and chats are locked until interest is accepted. Interact in a premium, secure environment.',
    }
  ];

  void nextOnboardingPage() {
    if (onboardingPage.value < onboardingData.length - 1) {
      onboardingController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  // Login Selection state
  final RxBool isOtpLogin = false.obs;
  
  // Login credentials
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxInt otpCountdown = 30.obs;
  Timer? _otpTimer;

  // Sign up fields
  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();

  // Forgot password field
  final TextEditingController resetEmailController = TextEditingController();

  void login() async {
    isLoading.value = true;
    try {
      bool success = false;
      if (isOtpLogin.value) {
        success = await _dbService.loginWithOTP(phoneController.text, otpController.text);
      } else {
        success = await _dbService.loginWithEmail(emailController.text, passwordController.text);
      }

      if (success) {
        Get.offAllNamed(AppRoutes.hub);
      } else {
        Get.snackbar('Error', 'Login failed. Please check credentials.',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void requestOTP() async {
    if (phoneController.text.isEmpty || phoneController.text.length < 10) {
      Get.snackbar('Invalid Input', 'Please enter a valid mobile number.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Mock network
    isLoading.value = false;
    
    Get.toNamed(AppRoutes.otp);
    _startOtpCountdown();
  }

  void _startOtpCountdown() {
    otpCountdown.value = 30;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpCountdown.value > 0) {
        otpCountdown.value--;
      } else {
        _otpTimer?.cancel();
      }
    });
  }

  void register() async {
    if (signupNameController.text.isEmpty ||
        signupEmailController.text.isEmpty ||
        signupPasswordController.text.isEmpty) {
      Get.snackbar('Incomplete Form', 'Please fill all details.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    
    // Redirect to profile creation wizard after basic sign up!
    Get.toNamed(AppRoutes.profileCreation);
  }

  void resetPassword() async {
    if (resetEmailController.text.isEmpty) {
      Get.snackbar('Email Required', 'Please enter your registered email.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    
    Get.snackbar('Success', 'Password reset instructions sent to your email.',
        backgroundColor: Colors.green, colorText: Colors.white);
    Get.back();
  }

  @override
  void onClose() {
    _otpTimer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    otpController.dispose();
    signupNameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    resetEmailController.dispose();
    onboardingController.dispose();
    super.onClose();
  }
}
