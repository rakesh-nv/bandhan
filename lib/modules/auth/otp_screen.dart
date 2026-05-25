import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants.dart';
import 'auth_controller.dart';

class OtpScreen extends GetView<AuthController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Enter Verification Code',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryMaroon,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    const TextSpan(text: 'We have sent a 4-digit verification code to '),
                    TextSpan(
                      text: controller.phoneController.text,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // OTP Digits Mock Inputs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: TextField(
                      autofocus: index == 0,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (val) {
                        if (val.isNotEmpty && index < 3) {
                          FocusScope.of(context).nextFocus();
                        } else if (val.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                        
                        // Mock combining digit triggers into otpController
                        if (index == 3) {
                          controller.otpController.text = '1234'; // Default mock code
                        }
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.input),
                          borderSide: const BorderSide(color: AppColors.secondaryGold, width: 2),
                        ),
                      ),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 48),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.login,
                  child: const Text('Verify & Proceed'),
                ),
              ),
              const SizedBox(height: 24),

              // Resend code timer
              Center(
                child: Obx(() {
                  final countdown = controller.otpCountdown.value;
                  if (countdown > 0) {
                    return Text(
                      'Resend code in $countdown seconds',
                      style: const TextStyle(color: AppColors.textDarkMuted),
                    );
                  } else {
                    return TextButton(
                      onPressed: controller.requestOTP,
                      child: const Text(
                        'Resend Verification OTP',
                        style: TextStyle(
                          color: AppColors.primaryMaroon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
