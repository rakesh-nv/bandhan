import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants.dart';
import '../../routes/routes.dart';
import 'auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve existing AuthController instance
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Brand Logo & Title
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryMaroon.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.secondaryGold, width: 1.5),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.primaryMaroon,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to Bandhan',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryMaroon,
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Trusted community matchmaking platform',
                      style: TextStyle(color: AppColors.textDarkMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Mode Selector (OTP / Email)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceCreamDim.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        final isOtp = controller.isOtpLogin.value;
                        return InkWell(
                          onTap: () => controller.isOtpLogin.value = true,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isOtp ? AppColors.primaryMaroon : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Mobile OTP',
                              style: TextStyle(
                                color: isOtp ? Colors.white : AppColors.textDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Expanded(
                      child: Obx(() {
                        final isOtp = controller.isOtpLogin.value;
                        return InkWell(
                          onTap: () => controller.isOtpLogin.value = false,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !isOtp ? AppColors.primaryMaroon : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Email & PW',
                              style: TextStyle(
                                color: !isOtp ? Colors.white : AppColors.textDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Inputs based on selected mode
              Obx(() {
                if (controller.isOtpLogin.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mobile Number',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone_outlined),
                          hintText: 'Enter 10-digit number',
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email Address',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: 'example@domain.com',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: AppColors.primaryMaroon, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline),
                          hintText: 'Enter password',
                        ),
                      ),
                    ],
                  );
                }
              }),
              const SizedBox(height: 40),

              // Action button (Login / Request OTP)
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final isOtp = controller.isOtpLogin.value;
                  return ElevatedButton(
                    onPressed: () {
                      if (isOtp) {
                        controller.requestOTP();
                      } else {
                        controller.login();
                      }
                    },
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(isOtp ? 'Send Verification OTP' : 'Login'),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Social Logins Header
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.surfaceCreamDim)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR CONNECT WITH', style: TextStyle(fontSize: 11, color: AppColors.textDarkMuted)),
                  ),
                  Expanded(child: Divider(color: AppColors.surfaceCreamDim)),
                ],
              ),
              const SizedBox(height: 24),

              // Social login row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(Icons.g_mobiledata, () {}),
                  const SizedBox(width: 24),
                  _buildSocialButton(Icons.facebook, () {}),
                  const SizedBox(width: 24),
                  _buildSocialButton(Icons.apple, () {}),
                ],
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 40),

              // Signup prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New to Bandhan? ', style: TextStyle(color: AppColors.textDarkMuted)),
                  InkWell(
                    onTap: () => Get.toNamed(AppRoutes.signup),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: AppColors.primaryMaroon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surfaceCreamDim.withOpacity(0.5)),
        ),
        child: Icon(
          icon,
          size: 28,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
