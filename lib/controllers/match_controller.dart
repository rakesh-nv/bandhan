import 'package:get/get.dart';
import 'package:bandhan/models/match_model.dart';
import 'package:bandhan/repositories/match_repository.dart';
import 'package:bandhan/services/auth_service.dart';

class MatchController extends GetxController {
  final MatchRepository _matchRepo = Get.find<MatchRepository>();
  final AuthService _authService = Get.find<AuthService>();
  
  final RxList<MatchModel> matches = <MatchModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (_authService.currentUserId != null) {
      fetchMatches();
    }
  }

  Future<void> fetchMatches() async {
    if (_authService.currentUserId == null) return;
    
    isLoading.value = true;
    try {
      final list = await _matchRepo.getMatches(_authService.currentUserId!);
      matches.value = list;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch matches');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createMatch(String user1Id, String user2Id) async {
    try {
      final newMatch = await _matchRepo.createMatch(user1Id, user2Id);
      matches.insert(0, newMatch);
    } catch (e) {
      print('Error creating match: \$e');
    }
  }
}
