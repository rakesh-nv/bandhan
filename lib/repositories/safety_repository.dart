import 'package:get/get.dart';
import 'package:bandhan/models/blocked_user_model.dart';
import 'package:bandhan/models/report_model.dart';
import 'package:bandhan/services/supabase_service.dart';

class SafetyRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  Future<BlockedUserModel> blockUser(String blockerId, String blockedId) async {
    final response = await _supabaseService.client
        .from('blocked_users')
        .insert({
          'blocker_id': blockerId,
          'blocked_id': blockedId,
        })
        .select()
        .single();
    return BlockedUserModel.fromJson(response);
  }

  Future<List<String>> getBlockedUserIds(String userId) async {
    final response = await _supabaseService.client
        .from('blocked_users')
        .select('blocked_id')
        .eq('blocker_id', userId);
        
    return (response as List).map((e) => e['blocked_id'] as String).toList();
  }

  Future<ReportModel> reportUser(ReportModel report) async {
    final response = await _supabaseService.client
        .from('reports')
        .insert(report.toJson())
        .select()
        .single();
    return ReportModel.fromJson(response);
  }
}
