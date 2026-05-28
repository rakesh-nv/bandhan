import 'package:get/get.dart';
import 'package:bandhan/models/profile_model.dart';
import 'package:bandhan/models/profile_photo_model.dart';
import 'package:bandhan/services/supabase_service.dart';

class ProfileRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final String _table = 'profiles';
  final String _photosTable = 'profile_photos';

  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final response = await _supabaseService.client
          .from(_table)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        return ProfileModel.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error getting profile: $e');
      rethrow;
    }
  }

  Future<ProfileModel> createProfile(ProfileModel profile) async {
    try {
      final response = await _supabaseService.client
          .from(_table)
          .insert(profile.toJson())
          .select()
          .single();
          
      return ProfileModel.fromJson(response);
    } catch (e) {
      print('Error creating profile: $e');
      rethrow;
    }
  }

  Future<ProfileModel> updateProfile(String userId, Map<String, dynamic> updates) async {
    try {
      final response = await _supabaseService.client
          .from(_table)
          .update(updates)
          .eq('id', userId)
          .select()
          .single();
          
      return ProfileModel.fromJson(response);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<List<ProfileModel>> getDiscoverProfiles({
    required String currentUserId,
    int limit = 20,
    int offset = 0,
    String? genderPref,
    int? minAge,
    int? maxAge,
  }) async {
    try {
      var query = _supabaseService.client
          .from(_table)
          .select()
          .neq('id', currentUserId);

      if (genderPref != null) {
        query = query.eq('gender', genderPref);
      }
      if (minAge != null) {
        query = query.gte('age', minAge);
      }
      if (maxAge != null) {
        query = query.lte('age', maxAge);
      }

      final response = await query
          .range(offset, offset + limit - 1)
          .order('created_at', ascending: false);

      return (response as List).map((e) => ProfileModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching discover profiles: $e');
      rethrow;
    }
  }

  // ─── Profile Photos (Gallery) CRUD Operations ───

  /// Fetch all gallery photos for a user
  Future<List<ProfilePhotoModel>> getGalleryPhotos(String userId) async {
    try {
      final response = await _supabaseService.client
          .from(_photosTable)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      return (response as List).map((e) => ProfilePhotoModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching gallery photos: $e');
      rethrow;
    }
  }

  /// Insert a new photo row into profile_photos
  Future<ProfilePhotoModel> insertGalleryPhoto(ProfilePhotoModel photo) async {
    try {
      final jsonMap = photo.toJson();
      // Remove id if it is empty so database auto-generates uuid
      if (photo.id.isEmpty) {
        jsonMap.remove('id');
      }
      final response = await _supabaseService.client
          .from(_photosTable)
          .insert(jsonMap)
          .select()
          .single();

      return ProfilePhotoModel.fromJson(response);
    } catch (e) {
      print('Error inserting gallery photo: $e');
      rethrow;
    }
  }

  /// Update an existing photo url in profile_photos
  Future<ProfilePhotoModel> updateGalleryPhoto(String photoId, String newUrl) async {
    try {
      final response = await _supabaseService.client
          .from(_photosTable)
          .update({'photo_url': newUrl})
          .eq('id', photoId)
          .select()
          .single();

      return ProfilePhotoModel.fromJson(response);
    } catch (e) {
      print('Error updating gallery photo: $e');
      rethrow;
    }
  }

  /// Delete a photo row from profile_photos
  Future<void> deleteGalleryPhoto(String photoId) async {
    try {
      await _supabaseService.client
          .from(_photosTable)
          .delete()
          .eq('id', photoId);
    } catch (e) {
      print('Error deleting gallery photo: $e');
      rethrow;
    }
  }
}
