import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/profile_model.dart';
import '../../models/interest_model.dart';
import '../../controllers/discover_controller.dart';
import '../../controllers/interest_controller.dart';
import '../../controllers/match_controller.dart';
import '../../services/auth_service.dart';

class HubController extends GetxController {
  final DiscoverController _discoverCtrl = Get.find<DiscoverController>();
  final InterestController _interestCtrl = Get.find<InterestController>();
  final MatchController _matchCtrl = Get.find<MatchController>();
  final AuthService _authService = Get.find<AuthService>();

  final RxInt activeTabIndex = 0.obs;
  final RxInt carouselIndex = 0.obs;
  
  // Carousel banners
  final List<Map<String, String>> banners = [
    {
      'title': 'Bandhan Premium',
      'subtitle': 'Get unlimited interests, unlocked chats, and verified badges today!',
      'cta': 'Upgrade Now',
    },
    {
      'title': 'Safe & Verified Matchmaking',
      'subtitle': 'Every single user undergoes standard ID & community validation.',
      'cta': 'Read Security Guidelines',
    },
  ];

  // Recommendations streams
  final RxList<ProfileModel> recommendations = <ProfileModel>[].obs;
  final RxList<ProfileModel> verifiedProfiles = <ProfileModel>[].obs;
  final RxList<ProfileModel> nearbyMatches = <ProfileModel>[].obs;
  
  final RxBool isLoadingFeed = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFeeds();
  }

  Future<void> loadFeeds() async {
    isLoadingFeed.value = true;
    try {
      await _discoverCtrl.fetchInitialProfiles();
      
      final list = _discoverCtrl.discoverProfiles;
      recommendations.assignAll(list);
      verifiedProfiles.assignAll(list.where((p) => p.isVerified).toList());
      nearbyMatches.assignAll(list.where((p) => (p.city ?? '').toLowerCase().contains('mumbai')).toList());
    } catch (e) {
      Get.snackbar('Error', 'Failed to load recommendations');
    } finally {
      isLoadingFeed.value = false;
    }
  }

  Future<void> sendInterest(String targetUserId) async {
    await _interestCtrl.sendInterest(targetUserId);
  }

  bool isInterestSent(String targetUserId) {
    return _interestCtrl.sentInterests.any((interest) =>
        interest.receiverId == targetUserId);
  }

  // Handle Interest lists by delegating to InterestController
  List<InterestModel> get receivedInterests => _interestCtrl.receivedInterests;
  List<InterestModel> get sentInterests => _interestCtrl.sentInterests;
  List<InterestModel> get acceptedInterests => _interestCtrl.acceptedInterests;

  void acceptInterest(InterestModel interest) async {
    final success = await _interestCtrl.acceptInterest(interest);
    if (success) {
      Get.snackbar('Success', 'Interest Accepted! You can now chat.',
          backgroundColor: Colors.green, colorText: Colors.white);
    }
    update();
  }

  void rejectInterest(String interestId) async {
    final success = await _interestCtrl.rejectInterest(interestId);
    if (success) {
      Get.snackbar('Declined', 'Interest declined.',
          backgroundColor: Colors.orange, colorText: Colors.white);
    }
    update();
  }
}
