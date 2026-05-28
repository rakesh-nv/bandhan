import 'package:get/get.dart';
import 'package:bandhan/models/profile_model.dart';
import 'package:bandhan/repositories/profile_repository.dart';
import 'package:bandhan/repositories/safety_repository.dart';
import 'package:bandhan/services/auth_service.dart';

class DiscoverController extends GetxController {
  final ProfileRepository _profileRepo = Get.find<ProfileRepository>();
  final SafetyRepository _safetyRepo = Get.find<SafetyRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<ProfileModel> discoverProfiles = <ProfileModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFetchingMore = false.obs;
  final RxBool hasReachedEnd = false.obs;

  int _offset = 0;
  final int _limit = 20;

  // Filters
  String? genderFilter;
  int? minAgeFilter;
  int? maxAgeFilter;
  
  List<String> _blockedUserIds = [];

  @override
  void onInit() {
    super.onInit();
    fetchInitialProfiles();
  }

  void setFilters({String? gender, int? minAge, int? maxAge}) {
    genderFilter = gender;
    minAgeFilter = minAge;
    maxAgeFilter = maxAge;
    fetchInitialProfiles();
  }

  Future<void> fetchInitialProfiles() async {
    if (_authService.currentUserId == null) return;
    
    isLoading.value = true;
    _offset = 0;
    hasReachedEnd.value = false;
    discoverProfiles.clear();

    try {
      // First, fetch blocked users to filter them out
      _blockedUserIds = await _safetyRepo.getBlockedUserIds(_authService.currentUserId!);
      
      await _fetchData();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMore() async {
    if (isFetchingMore.value || hasReachedEnd.value || _authService.currentUserId == null) return;
    
    isFetchingMore.value = true;
    try {
      _offset += _limit;
      await _fetchData();
    } finally {
      isFetchingMore.value = false;
    }
  }

  Future<void> _fetchData() async {
    final profiles = await _profileRepo.getDiscoverProfiles(
      currentUserId: _authService.currentUserId!,
      limit: _limit,
      offset: _offset,
      genderPref: genderFilter,
      minAge: minAgeFilter,
      maxAge: maxAgeFilter,
    );
    
    if (profiles.length < _limit) {
      hasReachedEnd.value = true;
    }
    
    // Filter out blocked users
    final filtered = profiles.where((p) => !_blockedUserIds.contains(p.id)).toList();
    discoverProfiles.addAll(filtered);
  }
}
