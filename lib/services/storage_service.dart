import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bandhan/services/supabase_service.dart';

class StorageService extends GetxService {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  static const String profileBucket = 'profile-images';
  static const String galleryBucket = 'gallery-images';

  Future<StorageService> init() async {
    return this;
  }

  /// Uploads a profile image to the 'profile-images' bucket
  Future<String?> uploadProfilePhoto(String userId, File file) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = '$userId/$fileName';

      await _supabaseService.client.storage
          .from(profileBucket)
          .upload(path, file, fileOptions: const FileOptions(upsert: true));

      final String publicUrl = _supabaseService.client.storage
          .from(profileBucket)
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      _handleStorageError(e, profileBucket);
      return null;
    }
  }

  /// Deletes a profile image from the 'profile-images' bucket using its full URL
  Future<bool> deleteProfilePhoto(String url) async {
    try {
      final String? path = _extractPathFromUrl(url, profileBucket);
      if (path == null) return false;

      await _supabaseService.client.storage
          .from(profileBucket)
          .remove([path]);
      return true;
    } catch (e) {
      print('Failed to delete profile photo: $e');
      return false;
    }
  }

  /// Uploads a gallery image to the 'gallery-images' bucket
  Future<String?> uploadGalleryPhoto(String userId, File file) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = '$userId/$fileName';

      await _supabaseService.client.storage
          .from(galleryBucket)
          .upload(path, file, fileOptions: const FileOptions(upsert: true));

      final String publicUrl = _supabaseService.client.storage
          .from(galleryBucket)
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      _handleStorageError(e, galleryBucket);
      return null;
    }
  }

  /// Deletes a gallery image from the 'gallery-images' bucket using its full URL
  Future<bool> deleteGalleryPhoto(String url) async {
    try {
      final String? path = _extractPathFromUrl(url, galleryBucket);
      if (path == null) return false;

      await _supabaseService.client.storage
          .from(galleryBucket)
          .remove([path]);
      return true;
    } catch (e) {
      print('Failed to delete gallery photo: $e');
      return false;
    }
  }

  /// Extracts the relative storage path (e.g. userId/filename.jpg) from a full Supabase public URL
  String? _extractPathFromUrl(String url, String bucket) {
    try {
      final marker = 'public/$bucket/';
      final index = url.indexOf(marker);
      if (index != -1) {
        return url.substring(index + marker.length);
      }
      
      // Fallback: extract the last two segments (e.g. user_id/file.jpg)
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.length >= 2) {
        return '${segments[segments.length - 2]}/${segments.last}';
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Gracefully catches missing bucket errors and instructs the user to configure them
  void _handleStorageError(dynamic e, String bucketName) {
    String errMsg = e.toString();
    bool isBucketNotFound = false;

    if (e is StorageException) {
      errMsg = e.message;
      final code = e.statusCode;
      if (code == '404' || errMsg.toLowerCase().contains('bucket not found') || errMsg.toLowerCase().contains('not found')) {
        isBucketNotFound = true;
      }
    } else {
      if (errMsg.toLowerCase().contains('bucket not found') || errMsg.toLowerCase().contains('not found') || errMsg.contains('404')) {
        isBucketNotFound = true;
      }
    }

    if (isBucketNotFound) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
              SizedBox(width: 8),
              Text('Storage Bucket Missing'),
            ],
          ),
          content: Text(
            'The Supabase storage bucket "$bucketName" was not found in your project.\n\n'
            'To resolve this:\n'
            '1. Go to your Supabase Dashboard.\n'
            '2. Open "Storage" from the left menu.\n'
            '3. Create a new bucket named "$bucketName".\n'
            '4. Toggle "Public bucket" to ENABLE public access.\n'
            '5. Save your new bucket.',
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Understood', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      Get.snackbar(
        'Upload Error',
        errMsg,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
