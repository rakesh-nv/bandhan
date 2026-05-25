import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/models.dart';
import '../../services/supabase_service.dart';

class SearchController extends GetxController {
  final SupabaseService _dbService = Get.find<SupabaseService>();
  SupabaseService get dbService => _dbService;

  final RxList<UserProfile> searchResults = <UserProfile>[].obs;
  final RxBool isLoading = false.obs;

  // View state
  final RxBool isGridView = true.obs;
  final RxString sortBy = 'compatibility'.obs; // compatibility, age, recentlyJoined

  // Filters State
  final RxDouble minAge = 20.0.obs;
  final RxDouble maxAge = 40.0.obs;
  
  final RxDouble minHeight = 140.0.obs;
  final RxDouble maxHeight = 200.0.obs;

  final RxDouble minSalary = 0.0.obs; // LPA

  final RxString religion = 'All'.obs;
  final RxString community = 'All'.obs;
  final RxString maritalStatus = 'All'.obs;

  // Constants lists
  final List<String> religions = ['All', 'Hindu', 'Muslim', 'Christian', 'Sikh', 'Jain', 'Buddhist'];
  final List<String> communities = ['All', 'Brahmin', 'Kayastha', 'Maratha', 'Rajput', 'Iyer', 'Iyengar', 'Patel', 'Nair'];
  final List<String> maritalStatuses = ['All', 'Never Married', 'Divorced', 'Widowed', 'Awaiting Divorce'];

  @override
  void onInit() {
    super.onInit();
    applyFilters();
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  void updateSort(String value) {
    sortBy.value = value;
    applyFilters();
  }

  void resetFilters() {
    minAge.value = 20.0;
    maxAge.value = 40.0;
    minHeight.value = 140.0;
    maxHeight.value = 200.0;
    minSalary.value = 0.0;
    religion.value = 'All';
    community.value = 'All';
    maritalStatus.value = 'All';
    applyFilters();
  }

  Future<void> applyFilters() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500)); // Mock latency

    final currentUser = _dbService.currentUser.value;
    final targetGender = currentUser?.gender == Gender.male ? Gender.female : Gender.male;

    // Start with all profiles of opposite gender
    var filtered = _dbService.mockProfiles.where((p) => p.gender == targetGender && p.id != currentUser?.id).toList();

    // Age Filter
    filtered = filtered.where((p) => p.age >= minAge.value && p.age <= maxAge.value).toList();

    // Height Filter
    filtered = filtered.where((p) => p.height >= minHeight.value && p.height <= maxHeight.value).toList();

    // Salary Filter
    filtered = filtered.where((p) => p.salary >= minSalary.value).toList();

    // Religion Filter
    if (religion.value != 'All') {
      filtered = filtered.where((p) => p.religion.toLowerCase() == religion.value.toLowerCase()).toList();
    }

    // Community Filter
    if (community.value != 'All') {
      filtered = filtered.where((p) => p.community.toLowerCase().contains(community.value.toLowerCase())).toList();
    }

    // Marital Status Filter
    if (maritalStatus.value != 'All') {
      filtered = filtered.where((p) {
        String statusLabel = 'Never Married';
        if (p.maritalStatus == MaritalStatus.divorced) statusLabel = 'Divorced';
        if (p.maritalStatus == MaritalStatus.widowed) statusLabel = 'Widowed';
        if (p.maritalStatus == MaritalStatus.awaitingDivorce) statusLabel = 'Awaiting Divorce';
        return statusLabel == maritalStatus.value;
      }).toList();
    }

    // Sorting
    if (sortBy.value == 'age') {
      filtered.sort((a, b) => a.age.compareTo(b.age));
    } else if (sortBy.value == 'recentlyJoined') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    searchResults.assignAll(filtered);
    isLoading.value = false;
  }
}
