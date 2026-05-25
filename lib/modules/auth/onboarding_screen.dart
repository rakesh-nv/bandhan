import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../routes/routes.dart';
import 'auth_controller.dart';

class OnboardingScreen extends GetView<AuthController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(AuthController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin, vertical: 20),
          child: Column(
            children: [
              // Top Logo/Skip bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite, color: AppColors.primaryMaroon, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'BANDHAN',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryMaroon,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.login),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: AppColors.textDarkMuted),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.signup),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(color: AppColors.primaryMaroon),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              
              const Spacer(),

              // Page Slider
              SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: controller.onboardingController,
                  onPageChanged: (index) {
                    controller.onboardingPage.value = index;
                  },
                  itemCount: controller.onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = controller.onboardingData[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Dynamic graphics / illustration mock (with beautiful decorative vectors)
                        Container(
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWhite,
                            borderRadius: BorderRadius.circular(AppRadius.container),
                            border: Border.all(color: AppColors.surfaceCreamDim.withOpacity(0.5)),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Decorative concentric circles
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.secondaryGold.withOpacity(0.08),
                                    width: 10,
                                  ),
                                ),
                              ),
                              Icon(
                                index == 0
                                    ? Icons.search_rounded
                                    : index == 1
                                        ? Icons.people_outline
                                        : Icons.lock_outline_rounded,
                                size: 80,
                                color: AppColors.primaryMaroon,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        Text(
                          data['title']!,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryMaroon,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data['subtitle']!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                height: 1.4,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Spacer(),

              // Bottom Indicator dots and Next button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicator dots
                  Row(
                    children: List.generate(
                      controller.onboardingData.length,
                      (index) => Obx(() {
                        final isSelected = controller.onboardingPage.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 6),
                          height: 8,
                          width: isSelected ? 24 : 8,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryMaroon
                                : AppColors.surfaceCreamDim,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Next Button
                  Obx(() {
                    final isLastPage =
                        controller.onboardingPage.value == controller.onboardingData.length - 1;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: controller.nextOnboardingPage,
                      child: Row(
                        children: [
                          Text(isLastPage ? 'Get Started' : 'Next'),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
