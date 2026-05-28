import 'package:get/get.dart';
import 'package:bandhan/models/subscription_model.dart';
import 'package:bandhan/repositories/subscription_repository.dart';
import 'package:bandhan/services/auth_service.dart';

class SubscriptionController extends GetxController {
  final SubscriptionRepository _subRepo = Get.find<SubscriptionRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final Rx<SubscriptionModel?> currentSubscription = Rx<SubscriptionModel?>(null);
  final RxBool isLoading = false.obs;

  bool get isPremium {
    final sub = currentSubscription.value;
    if (sub == null) return false;
    return sub.endDate != null && sub.endDate!.isAfter(DateTime.now());
  }

  @override
  void onInit() {
    super.onInit();
    if (_authService.currentUserId != null) {
      fetchSubscription();
    }
  }

  Future<void> fetchSubscription() async {
    if (_authService.currentUserId == null) return;
    
    isLoading.value = true;
    try {
      final sub = await _subRepo.getCurrentSubscription(_authService.currentUserId!);
      currentSubscription.value = sub;
    } catch (e) {
      print('Error fetching subscription: \$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> upgradePremium(String planName, double amount) async {
    if (_authService.currentUserId == null) return false;
    
    isLoading.value = true;
    try {
      // Typically you'd integrate Razorpay/Stripe here.
      // Assuming payment succeeds:
      final newSub = SubscriptionModel(
        id: '',
        userId: _authService.currentUserId!,
        planName: planName,
        amount: amount,
        paymentStatus: 'success',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)), // e.g. 1 month
      );
      
      final created = await _subRepo.createSubscription(newSub);
      currentSubscription.value = created;
      
      Get.snackbar('Success', 'Upgraded to Premium!');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to upgrade subscription');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
