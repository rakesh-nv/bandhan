import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants.dart';
import 'auth_controller.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Forgot Your Password?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryMaroon,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your registered email below, and we will send you instructions to reset your password.',
                style: TextStyle(color: AppColors.textDarkMuted, fontSize: 14),
              ),
              const SizedBox(height: 36),

              // Email Address Input
              const Text(
                'Email Address',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.resetEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'example@domain.com',
                ),
              ),
              const SizedBox(height: 40),

              // Send button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.resetPassword,
                  child: const Text('Send Reset Instructions'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
