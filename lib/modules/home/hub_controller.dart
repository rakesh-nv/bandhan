import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/models.dart';
import '../../services/supabase_service.dart';

class HubController extends GetxController {
  final SupabaseService dbService = Get.find<SupabaseService>();

  final RxInt activeTabIndex = 0.obs;
  final RxInt carouselIndex = 0.obs;
  
  // Carousel images and text
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
  final RxList<UserProfile> recommendations = <UserProfile>[].obs;
  final RxList<UserProfile> verifiedProfiles = <UserProfile>[].obs;
  final RxList<UserProfile> nearbyMatches = <UserProfile>[].obs;
  
  // Loading indicators
  final RxBool isLoadingFeed = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFeeds();
  }

  Future<void> loadFeeds() async {
    isLoadingFeed.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Mock latency
    
    // Sort and filter recommendations based on gender & basic preferences
    final curr = dbService.currentUser.value;
    final targetGender = curr?.gender == Gender.male ? Gender.female : Gender.male;
    
    final matches = dbService.mockProfiles.where((p) => p.gender == targetGender && p.id != curr?.id).toList();
    
    recommendations.assignAll(matches);
    verifiedProfiles.assignAll(matches.where((p) => p.isVerified).toList());
    nearbyMatches.assignAll(matches.where((p) => p.location.contains('Mumbai')).toList());
    
    isLoadingFeed.value = false;
  }

  Future<void> sendInterest(String targetUserId) async {
    await dbService.sendInterest(targetUserId);
    // Refresh local lists if needed
  }

  bool isInterestSent(String targetUserId) {
    return dbService.mockInterests.any((interest) =>
        interest.senderId == 'usr_curr' && interest.receiverId == targetUserId);
  }

  // Handle Interest tab lists
  List<Interest> get receivedInterests => dbService.mockInterests
      .where((i) => i.receiverId == 'usr_curr' && i.status == InterestStatus.pending)
      .toList();

  List<Interest> get sentInterests => dbService.mockInterests
      .where((i) => i.senderId == 'usr_curr')
      .toList();

  List<Interest> get acceptedInterests => dbService.mockInterests
      .where((i) => (i.senderId == 'usr_curr' || i.receiverId == 'usr_curr') && i.status == InterestStatus.accepted)
      .toList();

  void acceptInterest(String interestId) async {
    await dbService.acceptInterest(interestId);
    Get.snackbar('Success', 'Interest Accepted! You can now chat.',
        backgroundColor: Colors.green, colorText: Colors.white);
    update();
  }

  void rejectInterest(String interestId) async {
    await dbService.rejectInterest(interestId);
    Get.snackbar('Declined', 'Interest declined.',
        backgroundColor: Colors.orange, colorText: Colors.white);
    update();
  }
}
