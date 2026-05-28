import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhan/models/profile_model.dart';
import 'package:bandhan/models/profile_photo_model.dart';
import 'package:bandhan/repositories/profile_repository.dart';
import 'package:bandhan/services/auth_service.dart';
import 'package:bandhan/services/storage_service.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepo = Get.find<ProfileRepository>();
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();

  final Rx<ProfileModel?> currentProfile = Rx<ProfileModel?>(null);
  final RxList<ProfilePhotoModel> galleryPhotos = <ProfilePhotoModel>[].obs;
  
  final RxBool isLoading = false.obs;
  final RxBool isUploadingProfile = false.obs;
  final RxList<bool> isUploadingSlot = <bool>[false, false, false].obs;

  @override
  void onInit() {
    super.onInit();
    if (_authService.currentUserId != null) {
      loadProfileData();
    }
  }

  Future<void> loadProfileData() async {
    isLoading.value = true;
    try {
      await fetchCurrentProfile();
      await fetchGalleryPhotos();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCurrentProfile() async {
    if (_authService.currentUserId == null) return;
    try {
      final profile = await _profileRepo.getProfile(_authService.currentUserId!);
      currentProfile.value = profile;
    } catch (e) {
      print('Error fetching profile: $e');
      Get.snackbar('Profile Error', 'Could not fetch profile data',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> fetchGalleryPhotos() async {
    if (_authService.currentUserId == null) return;
    try {
      final photos = await _profileRepo.getGalleryPhotos(_authService.currentUserId!);
      galleryPhotos.value = photos;
    } catch (e) {
      print('Error fetching gallery photos: $e');
    }
  }

  Future<bool> createProfile(ProfileModel profile) async {
    isLoading.value = true;
    try {
      final newProfile = await _profileRepo.createProfile(profile);
      currentProfile.value = newProfile;
      return true;
    } catch (e) {
      print('Error creating profile: $e');
      Get.snackbar('Error', 'Failed to create profile: $e',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    if (_authService.currentUserId == null) return false;
    try {
      final updated = await _profileRepo.updateProfile(_authService.currentUserId!, updates);
      currentProfile.value = updated;
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar('Error', 'Failed to update profile',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }
  }

  /// Production-level Profile Photo management: Uploads new photo, updates DB, deletes old photo to prevent orphan images
  Future<void> uploadProfileImage(File file) async {
    if (_authService.currentUserId == null) return;

    isUploadingProfile.value = true;
    try {
      // 1. Keep track of current profile photo url for cleanup
      final oldUrl = currentProfile.value?.profilePhoto;

      // 2. Upload the new image to Supabase 'profile-images' bucket
      final newUrl = await _storageService.uploadProfilePhoto(_authService.currentUserId!, file);
      if (newUrl == null) return;

      // 3. Update the user profiles table
      final success = await updateProfile({'profile_photo': newUrl});
      if (success) {
        // 4. Delete the old photo from storage ONLY if database update succeeded
        if (oldUrl != null && oldUrl.isNotEmpty) {
          await _storageService.deleteProfilePhoto(oldUrl);
        }
        Get.snackbar(
          'Success', 
          'Profile photo updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Profile upload exception: $e');
      Get.snackbar('Error', 'Failed to upload profile photo',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isUploadingProfile.value = false;
    }
  }

  /// Adds a new gallery image (supports up to 3 gallery photos in total)
  Future<void> uploadGalleryImage(File file, int slotIndex) async {
    if (_authService.currentUserId == null) return;
    
    if (galleryPhotos.length >= 3) {
      Get.snackbar(
        'Limit Reached',
        'You can upload a maximum of 3 gallery photos.',
        backgroundColor: Colors.amber,
        colorText: Colors.white,
      );
      return;
    }

    if (slotIndex < 0 || slotIndex >= 3) return;
    isUploadingSlot[slotIndex] = true;

    try {
      // 1. Upload to Supabase 'gallery-images' bucket
      final url = await _storageService.uploadGalleryPhoto(_authService.currentUserId!, file);
      if (url == null) return;

      // 2. Create the Database Row
      final photoObj = ProfilePhotoModel(
        id: '', // Will be generated automatically by Postgres uuid
        userId: _authService.currentUserId!,
        photoUrl: url,
        isPrimary: false,
      );

      final newPhoto = await _profileRepo.insertGalleryPhoto(photoObj);
      galleryPhotos.add(newPhoto);

      Get.snackbar(
        'Uploaded',
        'Gallery photo added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Gallery upload error: $e');
      Get.snackbar('Upload Failed', 'Could not add image to gallery',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isUploadingSlot[slotIndex] = false;
    }
  }

  /// Replaces a specific gallery image at an index, cleaning up the storage
  Future<void> replaceGalleryImage(String id, String oldUrl, File file, int slotIndex) async {
    if (_authService.currentUserId == null || id.isEmpty) return;
    if (slotIndex < 0 || slotIndex >= 3) return;

    isUploadingSlot[slotIndex] = true;
    try {
      // 1. Upload new image
      final newUrl = await _storageService.uploadGalleryPhoto(_authService.currentUserId!, file);
      if (newUrl == null) return;

      // 2. Update DB row
      final updatedPhoto = await _profileRepo.updateGalleryPhoto(id, newUrl);
      
      // 3. Delete old file from storage
      if (oldUrl.isNotEmpty) {
        await _storageService.deleteGalleryPhoto(oldUrl);
      }

      // 4. Update local list state
      final idx = galleryPhotos.indexWhere((element) => element.id == id);
      if (idx != -1) {
        galleryPhotos[idx] = updatedPhoto;
      }

      Get.snackbar(
        'Updated',
        'Gallery image replaced successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Gallery replace error: $e');
      Get.snackbar('Update Failed', 'Could not replace gallery photo',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isUploadingSlot[slotIndex] = false;
    }
  }

  /// Deletes a gallery image completely from storage and DB
  Future<void> deleteGalleryImage(String id, String imageUrl, int slotIndex) async {
    if (id.isEmpty) return;
    if (slotIndex < 0 || slotIndex >= 3) return;

    isUploadingSlot[slotIndex] = true;
    try {
      // 1. Delete from database
      await _profileRepo.deleteGalleryPhoto(id);

      // 2. Delete from storage
      if (imageUrl.isNotEmpty) {
        await _storageService.deleteGalleryPhoto(imageUrl);
      }

      // 3. Update state
      galleryPhotos.removeWhere((element) => element.id == id);

      Get.snackbar(
        'Deleted',
        'Gallery image removed.',
        backgroundColor: Colors.grey[800],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Gallery deletion error: $e');
      Get.snackbar('Error', 'Failed to remove gallery photo',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isUploadingSlot[slotIndex] = false;
    }
  }
}
