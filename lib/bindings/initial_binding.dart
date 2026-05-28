import 'package:bandhan/modules/chat/chat_controller.dart';
import 'package:get/get.dart';

// Repositories
import 'package:bandhan/repositories/auth_repository.dart';
import 'package:bandhan/repositories/profile_repository.dart';
import 'package:bandhan/repositories/match_repository.dart';
import 'package:bandhan/repositories/chat_repository.dart';
import 'package:bandhan/repositories/notification_repository.dart';
import 'package:bandhan/repositories/subscription_repository.dart';
import 'package:bandhan/repositories/safety_repository.dart';

// Controllers
import 'package:bandhan/modules/auth/auth_controller.dart';
import 'package:bandhan/controllers/profile_controller.dart';
import 'package:bandhan/controllers/discover_controller.dart';
import 'package:bandhan/controllers/interest_controller.dart';
import 'package:bandhan/controllers/match_controller.dart';
import 'package:bandhan/controllers/notification_controller.dart';
import 'package:bandhan/controllers/subscription_controller.dart';
import 'package:bandhan/controllers/safety_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Note: SupabaseService is typically initialized before runApp in main.dart via Get.putAsync
    // So we don't put it here, assuming it's already in memory.
    
    // Note: Services are initialized asynchronously in main.dart before runApp.
    // We only put Repositories and Controllers here.

    // -- REPOSITORIES --
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<ProfileRepository>(() => ProfileRepository(), fenix: true);
    Get.lazyPut<MatchRepository>(() => MatchRepository(), fenix: true);
    Get.lazyPut<ChatRepository>(() => ChatRepository(), fenix: true);
    Get.lazyPut<NotificationRepository>(() => NotificationRepository(), fenix: true);
    Get.lazyPut<SubscriptionRepository>(() => SubscriptionRepository(), fenix: true);
    Get.lazyPut<SafetyRepository>(() => SafetyRepository(), fenix: true);

    // -- CONTROLLERS --
    // Controllers used globally or heavily can be put here

    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<DiscoverController>(() => DiscoverController(), fenix: true);
    Get.lazyPut<InterestController>(() => InterestController(), fenix: true);
    Get.lazyPut<MatchController>(() => MatchController(), fenix: true);
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(), fenix: true);
    Get.lazyPut<SubscriptionController>(() => SubscriptionController(), fenix: true);
    Get.lazyPut<SafetyController>(() => SafetyController(), fenix: true);
  }
}
