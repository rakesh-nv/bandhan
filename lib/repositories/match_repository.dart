import 'package:get/get.dart';
import 'package:bandhan/models/interest_model.dart';
import 'package:bandhan/models/match_model.dart';
import 'package:bandhan/services/supabase_service.dart';

class MatchRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  Future<InterestModel> sendInterest(String senderId, String receiverId) async {
    final response = await _supabaseService.client
        .from('interests')
        .insert({
          'sender_id': senderId,
          'receiver_id': receiverId,
          'status': 'pending',
        })
        .select()
        .single();
    return InterestModel.fromJson(response);
  }

  Future<InterestModel> updateInterestStatus(String interestId, String status) async {
    final response = await _supabaseService.client
        .from('interests')
        .update({'status': status})
        .eq('id', interestId)
        .select()
        .single();
    return InterestModel.fromJson(response);
  }

  Future<MatchModel> createMatch(String user1Id, String user2Id) async {
    final response = await _supabaseService.client
        .from('matches')
        .insert({
          'user1_id': user1Id,
          'user2_id': user2Id,
        })
        .select()
        .single();
    return MatchModel.fromJson(response);
  }

  Future<List<MatchModel>> getMatches(String userId) async {
    final response = await _supabaseService.client
        .from('matches')
        .select()
        .or('user1_id.eq.$userId,user2_id.eq.$userId')
        .order('matched_at', ascending: false);
        
    return (response as List).map((e) => MatchModel.fromJson(e)).toList();
  }

  Future<List<InterestModel>> getInterests(String userId) async {
    final response = await _supabaseService.client
        .from('interests')
        .select()
        .or('sender_id.eq.$userId,receiver_id.eq.$userId')
        .order('created_at', ascending: false);
    return (response as List).map((e) => InterestModel.fromJson(e)).toList();
  }
}
