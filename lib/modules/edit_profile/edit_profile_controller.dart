import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/profile_controller.dart';
import '../../models/profile_model.dart';
import '../../models/models.dart';

class EditProfileController extends GetxController {
  final ProfileController profileCtrl = Get.find<ProfileController>();

  // Text controllers
  late final TextEditingController fullNameController;
  late final TextEditingController cityController;
  late final TextEditingController educationController;
  late final TextEditingController professionController;
  late final TextEditingController companyNameController;
  late final TextEditingController bioController;

  // Reactive dropdown values
  final Rx<String?> selectedGender = Rx<String?>(null);
  final Rx<DateTime?> dob = Rx<DateTime?>(null);
  final Rx<String?> selectedReligion = Rx<String?>(null);
  final Rx<String?> selectedCommunity = Rx<String?>(null);

  // State
  final RxBool isSaving = false.obs;
  final RxBool isUploadingPhoto = false.obs;

  // Dropdown options – matching profile_creation_controller values
  final List<String> genderOptions = ['male', 'female'];
  final List<String> religionsList = [
    'Hindu', 'Muslim', 'Christian', 'Sikh', 'Jain', 'Buddhist', 'Jewish',
  ];
  final List<String> communitiesList = [
    'Brahmin', 'Kayastha', 'Maratha', 'Rajput', 'Iyer', 'Iyengar',
    'Patel', 'Nair', 'Sikh Ramgarhia', 'Jain Oswal',
  ];

  ProfileModel? get _profile => profileCtrl.currentProfile.value;

  @override
  void onInit() {
    super.onInit();
    _populateFields();
  }

  void _populateFields() {
    final p = _profile;
    fullNameController = TextEditingController(text: p?.fullName ?? '');
    cityController = TextEditingController(text: p?.city ?? '');
    educationController = TextEditingController(text: p?.education ?? '');
    professionController = TextEditingController(text: p?.profession ?? '');
    companyNameController = TextEditingController(text: p?.companyName ?? '');
    bioController = TextEditingController(text: p?.bio ?? '');

    selectedGender.value = p?.gender;
    dob.value = p?.dateOfBirth;
    selectedReligion.value = p?.religion;
    selectedCommunity.value = p?.community;
  }

  Future<void> pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) return;

      isUploadingPhoto.value = true;
      await profileCtrl.uploadProfileImage(File(image.path));
      Get.snackbar('Success', 'Profile photo updated!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update photo: $e',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  Future<void> saveProfile() async {
    // Build map of only changed fields
    final Map<String, dynamic> updates = {};
    final p = _profile;

    final newName = fullNameController.text.trim();
    if (newName.isNotEmpty && newName != p?.fullName) {
      updates['full_name'] = newName;
    }

    if (selectedGender.value != null && selectedGender.value != p?.gender) {
      updates['gender'] = selectedGender.value;
    }

    if (dob.value != null && dob.value != p?.dateOfBirth) {
      updates['date_of_birth'] = dob.value!.toIso8601String();
    }

    if (selectedReligion.value != null && selectedReligion.value != p?.religion) {
      updates['religion'] = selectedReligion.value;
    }

    if (selectedCommunity.value != null && selectedCommunity.value != p?.community) {
      updates['community'] = selectedCommunity.value;
    }

    final newCity = cityController.text.trim();
    if (newCity != (p?.city ?? '')) {
      updates['city'] = newCity;
    }

    final newEdu = educationController.text.trim();
    if (newEdu != (p?.education ?? '')) {
      updates['education'] = newEdu;
    }

    final newProf = professionController.text.trim();
    if (newProf != (p?.profession ?? '')) {
      updates['profession'] = newProf;
    }

    final newCompany = companyNameController.text.trim();
    if (newCompany != (p?.companyName ?? '')) {
      updates['company_name'] = newCompany;
    }

    final newBio = bioController.text.trim();
    if (newBio != (p?.bio ?? '')) {
      updates['bio'] = newBio;
    }

    if (updates.isEmpty) {
      Get.snackbar('No Changes', 'No fields were modified.',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // Add updated_at timestamp
    updates['updated_at'] = DateTime.now().toIso8601String();

    isSaving.value = true;
    try {
      final success = await profileCtrl.updateProfile(updates);
      if (success) {
        Get.snackbar('Success', 'Profile updated successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    cityController.dispose();
    educationController.dispose();
    professionController.dispose();
    companyNameController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
