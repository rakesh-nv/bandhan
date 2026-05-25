import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants.dart';
import '../../routes/routes.dart';
import 'auth_controller.dart';

class SignupScreen extends GetView<AuthController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Let\'s Get Started',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryMaroon,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create an account to search verified matches within your community.',
                style: TextStyle(color: AppColors.textDarkMuted, fontSize: 14),
              ),
              const SizedBox(height: 36),

              // Full Name
              const Text(
                'Full Name',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.signupNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Enter your full name',
                ),
              ),
              const SizedBox(height: 20),

              // Email
              const Text(
                'Email Address',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.signupEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'example@domain.com',
                ),
              ),
              const SizedBox(height: 20),

              // Password
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.signupPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: 'Create strong password',
                ),
              ),
              const SizedBox(height: 40),

              // Signup Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.register,
                  child: const Text('Create Account'),
                ),
              ),
              const SizedBox(height: 32),

              // Already have an account prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: TextStyle(color: AppColors.textDarkMuted)),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Text(
                      'Login',
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
}
