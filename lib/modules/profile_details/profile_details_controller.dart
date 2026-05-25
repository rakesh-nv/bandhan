import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/models.dart';
import '../../services/supabase_service.dart';
import '../../routes/routes.dart';
import '../../core/constants.dart';

class ProfileDetailsController extends GetxController {
  final SupabaseService _dbService = Get.find<SupabaseService>();
  SupabaseService get dbService => _dbService;

  late UserProfile profile;
  
  final RxInt activePhotoIndex = 0.obs;
  final RxBool isShortlisted = false.obs;
  final RxBool isInterestSent = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Retrieve profile from arguments
    profile = Get.arguments as UserProfile;
    
    // Check if interest has already been sent
    isInterestSent.value = _dbService.mockInterests.any((i) =>
        i.senderId == 'usr_curr' && i.receiverId == profile.id);
  }

  Future<void> sendInterest() async {
    if (isInterestSent.value) return;

    isInterestSent.value = true;
    await _dbService.sendInterest(profile.id);
    _showMatchSuccessDialog();
  }

  void toggleShortlist() {
    isShortlisted.value = !isShortlisted.value;
    Get.snackbar(
      isShortlisted.value ? 'Shortlisted' : 'Removed',
      isShortlisted.value
          ? '${profile.name} added to your shortlist.'
          : '${profile.name} removed from your shortlist.',
      backgroundColor: AppColors.primaryMaroon,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void reportUser() {
    Get.defaultDialog(
      title: 'Report User',
      middleText: 'Are you sure you want to report this profile? We will moderate the profile immediately.',
      textConfirm: 'Report',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        Get.back();
        Get.snackbar('Report Submitted', 'Thank you for reporting. Our moderation team is looking into this.',
            backgroundColor: Colors.orange, colorText: Colors.white);
      },
    );
  }

  void blockUser() {
    Get.defaultDialog(
      title: 'Block User',
      middleText: 'Blocking will remove this profile from all recommendations and chats. Proceed?',
      textConfirm: 'Block',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primaryMaroon,
      onConfirm: () {
        Get.back();
        Get.snackbar('User Blocked', '${profile.name} has been blocked.',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      },
    );
  }

  void shareProfile() {
    Get.snackbar('Share Profile', 'Profile link copied to clipboard.',
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _showMatchSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.container),
        ),
        backgroundColor: AppColors.surfaceCream,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.secondaryGold.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: AppColors.heartRed,
                  size: 54,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Interest Sent!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryMaroon,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'We have notified ${profile.name}. Once they accept, you will be connected.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Okay'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
