import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../repositories/auth_repository.dart';
import '../../services/auth_service.dart';
import '../../routes/routes.dart';

/// Unified AuthController – handles both core auth (Supabase) and UI state
/// for onboarding, login, signup, OTP, and forgot-password screens.
class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AuthService _authService = Get.find<AuthService>();

  // ─── Core Auth State ─────────────────────────────
  final RxBool isLoading = false.obs;
  bool get isAuthenticated => _authService.isAuthenticated;

  // ─── Onboarding ──────────────────────────────────
  final RxInt onboardingPage = 0.obs;
  final PageController onboardingController = PageController();
  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Find Your Perfect Match',
      'subtitle':
          'Discover trusted profiles verified within your community. Your journey to a lifelong partner starts here.',
    },
    {
      'title': 'Trusted Community Focus',
      'subtitle':
          'We connect hearts within small, close-knit communities where everyone is verified by trusted members.',
    },
    {
      'title': 'Secure & Private Conversations',
      'subtitle':
          'Photos and chats are locked until interest is accepted. Interact in a premium, secure environment.',
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

  // ─── Login UI State ──────────────────────────────
  final RxBool isOtpLogin = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final RxInt otpCountdown = 30.obs;
  Timer? _otpTimer;

  // ─── Signup UI State ─────────────────────────────
  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPhoneController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();

  // ─── Forgot Password ─────────────────────────────
  final TextEditingController resetEmailController = TextEditingController();

  // ─── Core Auth Methods ───────────────────────────

  Future<bool> loginWithEmail(String email, String password) async {
    isLoading.value = true;
    try {
      await _authRepository.signInWithEmail(email: email, password: password);
      return true;
    } on AuthException catch (e) {
      Get.snackbar('Login Failed', e.message);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signupWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    isLoading.value = true;
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      return true;
    } on AuthException catch (e) {
      Get.snackbar('Signup Failed', e.message);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepository.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out' );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    isLoading.value = true;
    try {
      await _authRepository.resetPassword(email);
      Get.snackbar('Success', 'Password reset email sent');
    } on AuthException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to send reset email');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── UI-facing Convenience Methods ───────────────

  void login() async {
    isLoading.value = true;
    try {
      bool success = false;
      if (isOtpLogin.value) {
        Get.snackbar('Coming Soon', 'OTP login is currently disabled.');
      } else {
        success = await loginWithEmail(
            emailController.text, passwordController.text);
      }

      if (success) {
        Get.offAllNamed(AppRoutes.hub);
      }
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
    await Future.delayed(const Duration(seconds: 1)); // Mock OTP network
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
        signupPhoneController.text.isEmpty ||
        signupPasswordController.text.isEmpty) {
      Get.snackbar('Incomplete Form', 'Please fill all details.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final success = await signupWithEmail(
        email: signupEmailController.text,
        password: signupPasswordController.text,
        name: signupNameController.text,
        phone: signupPhoneController.text,
      );
      if (success) {
        Get.toNamed(AppRoutes.profileCreation);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void resetPassword() async {
    if (resetEmailController.text.isEmpty) {
      Get.snackbar('Email Required', 'Please enter your registered email.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    await sendPasswordReset(resetEmailController.text);
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
    signupPhoneController.dispose();
    signupPasswordController.dispose();
    resetEmailController.dispose();
    onboardingController.dispose();
    super.onClose();
  }
}
