import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bandhan/services/supabase_service.dart';

class AuthService extends GetxService {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  
  final Rx<User?> currentUser = Rx<User?>(null);
  StreamSubscription<AuthState>? _authStateSubscription;

  Future<AuthService> init() async {
    // Initial user
    currentUser.value = _supabaseService.client.auth.currentUser;

    // Listen to auth changes
    _authStateSubscription = _supabaseService.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      currentUser.value = session?.user;
      
      if (event == AuthChangeEvent.signedIn) {
        // Handle login side effects
      } else if (event == AuthChangeEvent.signedOut) {
        // Handle logout side effects
      }
    });
    return this;
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    super.onClose();
  }

  bool get isAuthenticated => currentUser.value != null;
  String? get currentUserId => currentUser.value?.id;
}
