import 'package:get/get.dart';
import '../../models/profile_model.dart';
import '../../controllers/discover_controller.dart';

class SearchController extends GetxController {
  final DiscoverController _discoverCtrl = Get.find<DiscoverController>();

  final RxList<ProfileModel> searchResults = <ProfileModel>[].obs;
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
    
    // Instead of filtering locally, we could call the repository here. 
    // For now, let's trigger DiscoverController to fetch with new filters, 
    // or just filter whatever DiscoverController has already fetched.
    
    _discoverCtrl.setFilters(
      minAge: minAge.value.toInt(),
      maxAge: maxAge.value.toInt(),
    );
    
    // Wait for discover controller to finish loading
    await Future.delayed(const Duration(milliseconds: 500));
    
    var filtered = _discoverCtrl.discoverProfiles.toList();

    // Additional local filters not supported by DiscoverController yet
    if (religion.value != 'All') {
      filtered = filtered.where((p) => p.religion?.toLowerCase() == religion.value.toLowerCase()).toList();
    }

    if (community.value != 'All') {
      filtered = filtered.where((p) => (p.community ?? '').toLowerCase().contains(community.value.toLowerCase())).toList();
    }

    // Sorting
    if (sortBy.value == 'age') {
      filtered.sort((a, b) => (a.age ?? 0).compareTo(b.age ?? 0));
    } else if (sortBy.value == 'recentlyJoined') {
      filtered.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
    }

    searchResults.assignAll(filtered);
    isLoading.value = false;
  }
}
