import 'package:get/get.dart';
import 'package:bandhan/models/subscription_model.dart';
import 'package:bandhan/services/supabase_service.dart';

class SubscriptionRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  Future<SubscriptionModel?> getCurrentSubscription(String userId) async {
    final response = await _supabaseService.client
        .from('subscriptions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response != null) {
      return SubscriptionModel.fromJson(response);
    }
    return null;
  }

  Future<SubscriptionModel> createSubscription(SubscriptionModel sub) async {
    final response = await _supabaseService.client
        .from('subscriptions')
        .insert(sub.toJson())
        .select()
        .single();
        
    // Also update profile is_premium flag
    await _supabaseService.client
        .from('profiles')
        .update({
          'is_premium': true,
          'premium_start_date': sub.startDate?.toIso8601String(),
          'premium_end_date': sub.endDate?.toIso8601String(),
        })
        .eq('id', sub.userId);

    return SubscriptionModel.fromJson(response);
  }
}
