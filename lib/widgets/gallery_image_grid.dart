import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bandhan/core/constants.dart';
import 'package:bandhan/controllers/profile_controller.dart';
import 'package:bandhan/models/profile_photo_model.dart';

class GalleryImageGrid extends StatelessWidget {
  final ProfileController controller;
  
  const GalleryImageGrid({
    super.key,
    required this.controller,
  });

  Future<void> _processImageSelection(ImageSource source, int slotIndex, ProfilePhotoModel? oldPhoto) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80, // High compression ratios for optimized load times
      );

      if (pickedFile == null) return;
      
      Get.back(); // Dismiss bottom sheet
      
      final file = File(pickedFile.path);

      if (oldPhoto != null) {
        // Replacement Mode
        await controller.replaceGalleryImage(oldPhoto.id, oldPhoto.photoUrl, file, slotIndex);
      } else {
        // Fresh Upload Mode
        await controller.uploadGalleryImage(file, slotIndex);
      }
    } catch (e) {
      Get.snackbar(
        'Upload Failure',
        'Could not pick or process image: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void _showImageOptions(BuildContext context, int slotIndex, ProfilePhotoModel? oldPhoto) {
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
              oldPhoto != null ? 'Replace Gallery Image' : 'Add Gallery Image',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              oldPhoto != null
                  ? 'Replace this image with a new one. The old image will be deleted automatically.'
                  : 'Add up to 3 gallery photos to showcase your lifestyle & personality.',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textDarkMuted,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _processImageSelection(ImageSource.camera, slotIndex, oldPhoto),
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
                            'Take Photo',
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
                    onTap: () => _processImageSelection(ImageSource.gallery, slotIndex, oldPhoto),
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
                            'Pick from Gallery',
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

  void _confirmDelete(BuildContext context, ProfilePhotoModel photo, int slotIndex) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Gallery Image',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Plus Jakarta Sans'),
        ),
        content: const Text(
          'Are you sure you want to permanently delete this photo from your gallery? This will clear it from storage and database.',
          style: TextStyle(fontSize: 14, color: AppColors.textDarkMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textDarkMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteGalleryImage(photo.id, photo.photoUrl, slotIndex);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Gallery (Max 3)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              Obx(() => Text(
                '${controller.galleryPhotos.length} / 3 Uploaded',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: controller.galleryPhotos.length == 3
                      ? AppColors.primaryMaroon
                      : AppColors.textDarkMuted,
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0, // Strict square layout
          ),
          itemCount: 3, // Constrained slots
          itemBuilder: (context, index) {
            return Obx(() {
              final photos = controller.galleryPhotos;
              final isUploading = controller.isUploadingSlot[index];
              
              // Map index to existing photo if applicable
              final ProfilePhotoModel? photo = index < photos.length ? photos[index] : null;

              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: photo != null ? AppColors.surfaceCreamDim : Colors.transparent,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Photo state / Dashed empty state
                      if (photo != null)
                        _buildPhotoSlot(context, photo, index)
                      else if (!isUploading)
                        _buildEmptySlot(context, index),

                      // Uploading / replacing shimmer overlay
                      if (isUploading)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.secondaryGold,
                                    strokeWidth: 2.0,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Uploading...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildPhotoSlot(BuildContext context, ProfilePhotoModel photo, int slotIndex) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gallery Image with Caching
        CachedNetworkImage(
          imageUrl: photo.photoUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.surfaceCream,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.primaryMaroon,
                  strokeWidth: 1.5,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.surfaceCreamHigh,
            child: const Icon(Icons.broken_image, color: AppColors.primaryMaroon),
          ),
        ),

        // Elegant Dark Gradient on bottom for tools
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.45),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.55),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Replace Button (Top Right)
        Positioned(
          top: 6,
          right: 6,
          child: InkWell(
            onTap: () => _showImageOptions(context, slotIndex, photo),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: AppColors.primaryMaroon,
                size: 14,
              ),
            ),
          )
          .animate()
          .scale(duration: 200.ms),
        ),

        // Delete Button (Bottom Right)
        Positioned(
          bottom: 6,
          right: 6,
          child: InkWell(
            onTap: () => _confirmDelete(context, photo, slotIndex),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          )
          .animate()
          .scale(duration: 200.ms),
        ),
      ],
    );
  }

  Widget _buildEmptySlot(BuildContext context, int slotIndex) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: AppColors.surfaceCreamDim.withOpacity(0.8)),
      child: InkWell(
        onTap: () => _showImageOptions(context, slotIndex, null),
        child: Container(
          color: AppColors.surfaceCream.withOpacity(0.4),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.add_a_photo_outlined,
                color: AppColors.secondaryGold,
                size: 26,
              ),
              SizedBox(height: 6),
              Text(
                'Add Photo',
                style: TextStyle(
                  color: AppColors.textDarkMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth),
      const Radius.circular(16),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = Path();

    double distance = 0.0;
    for (var metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
