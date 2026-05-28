import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/models.dart';
import '../../routes/routes.dart';
import '../../services/auth_service.dart' as core_auth;
import '../../controllers/profile_controller.dart';
import '../../models/profile_model.dart';
import '../../services/supabase_service.dart';
import '../auth/auth_controller.dart';

class ProfileCreationController extends GetxController {
  final RxInt currentStep = 0.obs;
  final int totalSteps = 4;

  // Step 1: Personal
  final Rx<Gender> selectedGender = Gender.female.obs;
  final Rx<DateTime?> dob = Rx<DateTime?>(null);

  // Reactive age variable
  final RxInt calculatedAge = 0.obs;

  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final Rx<MaritalStatus> selectedMaritalStatus =
      MaritalStatus.neverMarried.obs;

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

  final List<String> religionsList = [
    'Hindu',
    'Muslim',
    'Christian',
    'Sikh',
    'Jain',
    'Buddhist',
    'Jewish',
  ];

  final List<String> communitiesList = [
    'Brahmin',
    'Kayastha',
    'Maratha',
    'Rajput',
    'Iyer',
    'Iyengar',
    'Patel',
    'Nair',
    'Sikh Ramgarhia',
    'Jain Oswal',
  ];

  // =========================
  // Calculate Age Function
  // =========================

  void calculateAge(DateTime birthDate) {
    final today = DateTime.now();

    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    calculatedAge.value = age;
  }

  // =========================
  // Navigation Steps
  // =========================

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

  // =========================
  // Validation
  // =========================

  bool _validateCurrentStep() {
    if (currentStep.value == 0) {
      if (dob.value == null) {
        Get.snackbar(
          'Validation Error',
          'Please select your Date of Birth',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }

      if (heightController.text.isEmpty ||
          double.tryParse(heightController.text) == null) {
        Get.snackbar(
          'Validation Error',
          'Please enter a valid height in cm',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }

      return true;
    }

    if (currentStep.value == 1) {
      if (motherTongueController.text.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter mother tongue',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }

      if (locationController.text.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter your city/state location',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }

      return true;
    }

    if (currentStep.value == 2) {
      if (educationController.text.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter your education degree',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }

      if (professionController.text.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter your profession',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }

      if (salaryController.text.isEmpty ||
          double.tryParse(salaryController.text) == null) {
        Get.snackbar(
          'Validation Error',
          'Please enter your annual salary',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }

      return true;
    }

    return true;
  }

  // =========================
  // Submit Profile
  // =========================

  void _submitProfile() async {
    isSubmitting.value = true;

    try {
      final authService = Get.find<core_auth.AuthService>();
      final profileCtrl = Get.find<ProfileController>();

      if (authService.currentUserId == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      // Retrieve sign up data from AuthController
      final authCtrl = Get.find<AuthController>();

      final fullName = authCtrl.signupNameController.text.trim().isNotEmpty
          ? authCtrl.signupNameController.text.trim()
          : 'User ${authService.currentUserId!.substring(0, 4)}';

      final email = authCtrl.signupEmailController.text.trim().isNotEmpty
          ? authCtrl.signupEmailController.text.trim()
          : authService.currentUser.value?.email;

      final phone = authCtrl.signupPhoneController.text.trim().isNotEmpty
          ? authCtrl.signupPhoneController.text.trim()
          : null;

      // Update phone number in Supabase Auth
      if (phone != null) {
        try {
          final supabaseService = Get.find<SupabaseService>();

          await supabaseService.client.auth.updateUser(
            UserAttributes(phone: phone),
          );
        } catch (authError) {
          print('Optional update of auth phone number failed: $authError');
        }
      }

      final newProfile = ProfileModel(
        id: authService.currentUserId!,

        fullName: fullName,

        email: email,

        phoneNumber: phone,

        gender: selectedGender.value.toString().split('.').last,

        dateOfBirth: dob.value,

        // Reactive Age
        age: calculatedAge.value,

        religion: selectedReligion.value,
        community: selectedCommunity.value,
        caste: selectedCommunity.value,
        education: educationController.text,

        profession: professionController.text,

        city: locationController.text,

        bio: bioController.text,

        profilePhoto: selectedGender.value == Gender.male
            ? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&fit=crop&q=80'
            : 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&fit=crop&q=80',

        isProfileCompleted: true,
      );

      final success = await profileCtrl.createProfile(newProfile);

      if (success) {
        Get.snackbar(
          'Success',
          'Profile completed successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(AppRoutes.hub);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // =========================
  // Dispose Controllers
  // =========================

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
