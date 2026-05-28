import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bandhan/services/supabase_service.dart';

class AuthRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    return await _supabaseService.client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': name,
        'phone': phone,
      },
    );
  }

  Future<AuthResponse> signInWithEmail({required String email, required String password}) async {
    return await _supabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabaseService.client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _supabaseService.client.auth.resetPasswordForEmail(email);
  }
}
