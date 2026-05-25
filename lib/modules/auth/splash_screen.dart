import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Put controller to bootstrap its timer
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.primaryMaroon,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Elegant traditional design motif outlines in background (using custom customPaint or circular containers)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.secondaryGold.withOpacity(0.06),
                  width: 20,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.secondaryGold.withOpacity(0.04),
                  width: 30,
                ),
              ),
            ),
          ),

          // Central Logo and Branding
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Calligraphy/Mandala motif
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.secondaryGold,
                      width: 2.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.favorite,
                    color: AppColors.secondaryGold,
                    size: 40,
                  ),
                )
                .animate()
                .scale(duration: 800.ms, curve: Curves.elasticOut)
                .then()
                .shake(duration: 500.ms, hz: 2),

                const SizedBox(height: 24),
                
                Text(
                  'BANDHAN',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.secondaryGold,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4.0,
                  ),
                )
                .animate()
                .fade(delay: 300.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0.0),

                const SizedBox(height: 8),

                Text(
                  'TRUSTED COMMUNITY MATRIMONY',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
                .animate()
                .fade(delay: 500.ms, duration: 600.ms),
              ],
            ),
          ),

          // Secure verification note bottom footer
          Positioned(
            bottom: 40,
            child: Row(
              children: const [
                Icon(Icons.security, color: AppColors.secondaryGold, size: 16),
                SizedBox(width: 8),
                Text(
                  '100% Verified Community Profiles',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
            .animate()
            .fade(delay: 800.ms, duration: 600.ms),
          ),
        ],
      ),
    );
  }
}
