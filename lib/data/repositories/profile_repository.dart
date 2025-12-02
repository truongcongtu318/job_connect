import 'package:fpdart/fpdart.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/data_sources/supabase_service.dart';
import 'package:job_connect/data/models/profile_model.dart';

/// Profile repository
class ProfileRepository {
  final _client = SupabaseService.client;

  /// Get profile by ID
  Future<Either<String, ProfileModel>> getProfileById(String profileId) async {
    try {
      final data =
          await _client.from('profiles').select().eq('id', profileId).single();

      final profile = ProfileModel.fromJson(data);
      AppLogger.info('Fetched profile: ${profile.id}');
      return right(profile);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching profile by ID', e, stackTrace);
      return left('Không thể tải thông tin profile');
    }
  }

  /// Get current user profile
  Future<Either<String, ProfileModel>> getCurrentUserProfile() async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) {
        return left('Người dùng chưa đăng nhập');
      }

      return await getProfileById(userId);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching current user profile', e, stackTrace);
      return left('Không thể tải thông tin profile');
    }
  }

  /// Update profile
  Future<Either<String, ProfileModel>> updateProfile({
    required String profileId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final data =
          await _client
              .from('profiles')
              .update(updates)
              .eq('id', profileId)
              .select()
              .single();

      final profile = ProfileModel.fromJson(data);
      AppLogger.info('Updated profile: ${profile.id}');
      return right(profile);
    } catch (e, stackTrace) {
      AppLogger.error('Error updating profile', e, stackTrace);
      return left('Không thể cập nhật profile');
    }
  }
}
