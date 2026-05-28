import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bandhan/core/constants.dart';
import 'package:bandhan/controllers/profile_controller.dart';

class ProfileImagePicker extends StatelessWidget {
  final ProfileController controller;
  
  const ProfileImagePicker({
    super.key,
    required this.controller,
  });

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024, // Production-grade resolution limit
        maxHeight: 1024,
        imageQuality: 80, // Optimized compression to reduce size by 70%+
      );

      if (pickedFile == null) return;
      
      Get.back(); // Close bottom sheet
      await controller.uploadProfileImage(File(pickedFile.path));
    } catch (e) {
      Get.snackbar(
        'Image Pick Error',
        'Could not access selected image: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void _showSourceSelector(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Profile Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select a high-quality community photo to attract matches.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textDarkMuted,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickImage(ImageSource.camera),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCream,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceCreamDim.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.camera_alt_outlined, color: AppColors.primaryMaroon, size: 28),
                          SizedBox(height: 8),
                          Text(
                            'Camera',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickImage(ImageSource.gallery),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCream,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceCreamDim.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.photo_library_outlined, color: AppColors.primaryMaroon, size: 28),
                          SizedBox(height: 8),
                          Text(
                            'Gallery',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Obx(() {
            final photoUrl = controller.currentProfile.value?.profilePhoto;
            final isUploading = controller.isUploadingProfile.value;

            return GestureDetector(
              onTap: isUploading ? null : () => _showSourceSelector(context),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer premium gold ring
                  Container(
                    width: 124,
                    height: 124,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryMaroon.withOpacity(0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4), // Thickness of gold border
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: ClipOval(
                        child: photoUrl != null && photoUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: photoUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.surfaceCreamHigh,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryMaroon,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => _buildDefaultAvatar(),
                              )
                            : _buildDefaultAvatar(),
                      ),
                    ),
                  )
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.easeOutBack),
                  
                  // Semi-transparent Uploading/Loading Overlay
                  if (isUploading)
                    Container(
                      width: 116,
                      height: 116,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.secondaryGold,
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Saving...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Camera Badge Icon overlay
                  if (!isUploading)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryMaroon,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    )
                    .animate(delay: 200.ms)
                    .scale(duration: 300.ms, curve: Curves.elasticOut),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          Text(
            'Primary Profile Image',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Visible to all matchmaking members',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textDarkMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.surfaceCreamHigh,
      child: const Center(
        child: Icon(
          Icons.person,
          size: 54,
          color: AppColors.primaryMaroon,
        ),
      ),
    );
  }
}
