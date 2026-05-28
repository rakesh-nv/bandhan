import 'package:get/get.dart';
import '../modules/auth/auth_binding.dart';
import 'routes.dart';
import '../modules/auth/splash_screen.dart';
import '../modules/auth/onboarding_screen.dart';
import '../modules/auth/login_screen.dart';
import '../modules/auth/otp_screen.dart';
import '../modules/auth/signup_screen.dart';
import '../modules/auth/forgot_password_screen.dart';
import '../modules/profile_creation/profile_creation_screen.dart';
import '../modules/home/hub_screen.dart';
import '../modules/search/search_screen.dart';
import '../modules/profile_details/profile_details_screen.dart';
import '../modules/chat/chat_screen.dart';
import '../modules/subscription/subscription_screen.dart';
import '../modules/admin/admin_dashboard_screen.dart';
import '../modules/edit_profile/edit_profile_screen.dart';

class AppPages {

  static const String initial = AppRoutes.splash;

  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen(),),

    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen(), transition: Transition.fadeIn,),

    GetPage(name: AppRoutes.login, page: () => const LoginScreen(),   transition: Transition.rightToLeft,),

    GetPage(name: AppRoutes.otp, page: () => const OtpScreen(),   transition: Transition.rightToLeft,),

    GetPage(name: AppRoutes.signup, page: () => const SignupScreen(),   transition: Transition.rightToLeft,),

    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordScreen(),  transition: Transition.rightToLeft,),

    GetPage(name: AppRoutes.profileCreation, page: () => const ProfileCreationScreen(), transition: Transition.rightToLeft,),

    GetPage(name: AppRoutes.hub, page: () => const HubScreen(), transition: Transition.fadeIn,),

    GetPage(name: AppRoutes.search, page: () => const SearchScreen(), transition: Transition.downToUp,),

    GetPage(name: AppRoutes.profileDetails, page: () => const ProfileDetailsScreen(), transition: Transition.rightToLeft,),

    GetPage(name: AppRoutes.chat, page: () => const ChatScreen(), transition: Transition.rightToLeft,),

    GetPage(name: AppRoutes.subscription, page: () => const SubscriptionScreen(), transition: Transition.downToUp,),

    GetPage(name: AppRoutes.admin, page: () => const AdminDashboardScreen(), transition: Transition.downToUp,),

    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen(), transition: Transition.rightToLeft,),
  ];
}
