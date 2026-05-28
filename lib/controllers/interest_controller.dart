import 'package:get/get.dart';
import 'package:bandhan/models/interest_model.dart';
import 'package:bandhan/repositories/match_repository.dart';
import 'package:bandhan/repositories/profile_repository.dart';
import 'package:bandhan/services/auth_service.dart';
import 'package:bandhan/controllers/match_controller.dart';

class InterestController extends GetxController {
  final MatchRepository _matchRepo = Get.find<MatchRepository>();
  final ProfileRepository _profileRepo = Get.find<ProfileRepository>();
  final AuthService _authService = Get.find<AuthService>();
  
  final RxList<InterestModel> pendingInterests = <InterestModel>[].obs;
  final RxList<InterestModel> receivedInterests = <InterestModel>[].obs;
  final RxList<InterestModel> sentInterests = <InterestModel>[].obs;
  final RxList<InterestModel> acceptedInterests = <InterestModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (_authService.currentUserId != null) {
      fetchInterests();
    }
  }

  Future<void> fetchInterests() async {
    if (_authService.currentUserId == null) return;
    
    isLoading.value = true;
    try {
      final list = await _matchRepo.getInterests(_authService.currentUserId!);
      
      final List<InterestModel> receivedList = [];
      final List<InterestModel> sentList = [];
      final List<InterestModel> acceptedList = [];
      
      for (var interest in list) {
        final String otherUserId = interest.senderId == _authService.currentUserId
            ? interest.receiverId
            : interest.senderId;
            
        final otherProfile = await _profileRepo.getProfile(otherUserId);
        final populatedInterest = interest.copyWith(otherProfile: otherProfile);
        
        if (interest.status == 'accepted') {
          acceptedList.add(populatedInterest);
        } else if (interest.senderId == _authService.currentUserId) {
          sentList.add(populatedInterest);
        } else if (interest.receiverId == _authService.currentUserId && interest.status == 'pending') {
          receivedList.add(populatedInterest);
        }
      }
      
      receivedInterests.assignAll(receivedList);
      sentInterests.assignAll(sentList);
      acceptedInterests.assignAll(acceptedList);
      pendingInterests.assignAll(receivedList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch interests');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendInterest(String receiverId) async {
    if (_authService.currentUserId == null) return false;
    
    isLoading.value = true;
    try {
      await _matchRepo.sendInterest(_authService.currentUserId!, receiverId);
      Get.snackbar('Success', 'Interest sent successfully');
      await fetchInterests();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to send interest or already sent');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> acceptInterest(InterestModel interest) async {
    isLoading.value = true;
    try {
      await _matchRepo.updateInterestStatus(interest.id, 'accepted');
      
      // Auto-create a match
      final matchCtrl = Get.find<MatchController>();
      await matchCtrl.createMatch(interest.senderId, interest.receiverId);
      
      await fetchInterests();
      Get.snackbar('Success', 'Interest accepted! You are now matched.');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept interest');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> rejectInterest(String interestId) async {
    isLoading.value = true;
    try {
      await _matchRepo.updateInterestStatus(interestId, 'rejected');
      await fetchInterests();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject interest');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
