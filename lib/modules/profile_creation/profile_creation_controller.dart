import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/models.dart';
import '../../services/supabase_service.dart';
import '../../routes/routes.dart';

class ProfileCreationController extends GetxController {
  final SupabaseService _dbService = Get.find<SupabaseService>();

  final RxInt currentStep = 0.obs;
  final int totalSteps = 4;

  // Step 1: Personal
  final Rx<Gender> selectedGender = Gender.female.obs;
  final Rx<DateTime?> dob = Rx<DateTime?>(null);
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final Rx<MaritalStatus> selectedMaritalStatus = MaritalStatus.neverMarried.obs;

  // Step 2: Cultural
  final RxString selectedReligion = 'Hindu'.obs;
  final RxString selectedCommunity = 'Brahmin'.obs;
  final motherTongueController = TextEditingController();
  final locationController = TextEditingController();

  // Step 3: Professional
  final educationController = TextEditingController();
  final professionController = TextEditingController();
  final salaryController = TextEditingController();
  final bioController = TextEditingController();

  // Step 4: Family & Preferences
  final familyController = TextEditingController();
  final RxDouble minPartnerAge = 22.0.obs;
  final RxDouble maxPartnerAge = 35.0.obs;
  final RxDouble minPartnerSalary = 5.0.obs;

  final RxBool isSubmitting = false.obs;

  final List<String> religionsList = ['Hindu', 'Muslim', 'Christian', 'Sikh', 'Jain', 'Buddhist', 'Jewish'];
  final List<String> communitiesList = ['Brahmin', 'Kayastha', 'Maratha', 'Rajput', 'Iyer', 'Iyengar', 'Patel', 'Nair', 'Sikh Ramgarhia', 'Jain Oswal'];

  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      if (_validateCurrentStep()) {
        currentStep.value++;
      }
    } else {
      _submitProfile();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  bool _validateCurrentStep() {
    if (currentStep.value == 0) {
      if (dob.value == null) {
        Get.snackbar('Validation Error', 'Please select your Date of Birth',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return false;
      }
      if (heightController.text.isEmpty || double.tryParse(heightController.text) == null) {
        Get.snackbar('Validation Error', 'Please enter a valid height in cm',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return false;
      }
      return true;
    }
    
    if (currentStep.value == 1) {
      if (motherTongueController.text.isEmpty) {
        Get.snackbar('Validation Error', 'Please enter mother tongue',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return false;
      }
      if (locationController.text.isEmpty) {
        Get.snackbar('Validation Error', 'Please enter your city/state location',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return false;
      }
      return true;
    }

    if (currentStep.value == 2) {
      if (educationController.text.isEmpty) {
        Get.snackbar('Validation Error', 'Please enter your education degree',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return false;
      }
      if (professionController.text.isEmpty) {
        Get.snackbar('Validation Error', 'Please enter your profession',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return false;
      }
      if (salaryController.text.isEmpty || double.tryParse(salaryController.text) == null) {
        Get.snackbar('Validation Error', 'Please enter your annual salary',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return false;
      }
      return true;
    }

    return true;
  }

  void _submitProfile() async {
    isSubmitting.value = true;
    try {
      final newProfile = UserProfile(
        id: 'usr_curr',
        name: _dbService.currentUser.value?.name ?? 'Rahul Sharma', // Preserve basic name
        gender: selectedGender.value,
        dateOfBirth: dob.value ?? DateTime(1995, 1, 1),
        religion: selectedReligion.value,
        community: selectedCommunity.value,
        motherTongue: motherTongueController.text,
        education: educationController.text,
        profession: professionController.text,
        salary: double.tryParse(salaryController.text) ?? 10.0,
        height: double.tryParse(heightController.text) ?? 170.0,
        weight: double.tryParse(weightController.text) ?? 65.0,
        maritalStatus: selectedMaritalStatus.value,
        location: locationController.text,
        bio: bioController.text,
        familyDetails: familyController.text,
        partnerPreferences: PartnerPreferences(
          minAge: minPartnerAge.value.toInt(),
          maxAge: maxPartnerAge.value.toInt(),
          minSalary: minPartnerSalary.value,
        ),
        photoUrls: [
          // Give default avatar depending on gender selected
          selectedGender.value == Gender.male
              ? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&fit=crop&q=80'
              : 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&fit=crop&q=80'
        ],
        isVerified: false,
        isPremium: false,
        createdAt: DateTime.now(),
      );

      // Save in mock service
      _dbService.currentUser.value = newProfile;
      _dbService.mockProfiles.add(newProfile);

      Get.snackbar('Success', 'Profile completed successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);
      
      Get.offAllNamed(AppRoutes.hub);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    heightController.dispose();
    weightController.dispose();
    motherTongueController.dispose();
    locationController.dispose();
    educationController.dispose();
    professionController.dispose();
    salaryController.dispose();
    bioController.dispose();
    familyController.dispose();
    super.onClose();
  }
}
