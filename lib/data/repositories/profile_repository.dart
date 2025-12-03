import 'package:fpdart/fpdart.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Profile repository
class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

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
      final userId = _client.auth.currentUser?.id;
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

  /// Upload resume to Supabase Storage
  Future<Either<String, String>> uploadResume({
    required String userId,
    required dynamic file,
    required String fileName,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '$userId/${timestamp}_$fileName';

      // Upload file to storage
      await _client.storage
          .from('resumes')
          .uploadBinary(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get public URL
      final url = _client.storage.from('resumes').getPublicUrl(path);

      // Update profile with new resume URL
      await updateProfile(profileId: userId, updates: {'resume_url': url});

      AppLogger.info('Resume uploaded and profile updated: $path');
      return right(url);
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading resume', e, stackTrace);
      return left('Không thể tải lên CV. Vui lòng thử lại');
    }
  }

  /// Upload avatar to Supabase Storage
  Future<Either<String, String>> uploadAvatar({
    required String authUserId, // For Storage RLS
    required String profileId, // For DB update
    required dynamic file,
    required String fileName,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      // Use authUserId for the folder path to match RLS policy
      final path = '$authUserId/avatar_${timestamp}_$fileName';

      // Upload file to storage
      await _client.storage
          .from('avatars')
          .uploadBinary(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get public URL
      final url = _client.storage.from('avatars').getPublicUrl(path);

      // Update profile with new avatar URL
      await updateProfile(profileId: profileId, updates: {'avatar_url': url});

      AppLogger.info('Avatar uploaded and profile updated: $path');
      return right(url);
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading avatar', e, stackTrace);
      return left('Không thể tải lên ảnh đại diện. Vui lòng thử lại');
    }
  }
}
