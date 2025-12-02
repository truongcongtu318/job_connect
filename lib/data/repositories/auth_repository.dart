import 'package:fpdart/fpdart.dart';
import 'package:job_connect/data/data_sources/supabase_service.dart';
import 'package:job_connect/data/models/user_model.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentication repository
class AuthRepository {
  final SupabaseClient _client = SupabaseService.client;

  /// Sign in with email and password
  Future<Either<String, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return left('Đăng nhập thất bại');
      }

      // Get user profile
      final profileData =
          await _client
              .from('profiles')
              .select()
              .eq('user_id', response.user!.id)
              .maybeSingle();

      if (profileData == null) {
        // Profile doesn't exist - this shouldn't happen
        AppLogger.error('Profile not found for user: ${response.user!.id}');
        // Sign out the user
        await _client.auth.signOut();
        return left('Hồ sơ người dùng không tồn tại. Vui lòng đăng ký lại.');
      }

      final userModel = UserModel.fromJson(profileData);
      AppLogger.info('User signed in: ${userModel.email}');
      return right(userModel);
    } on AuthException catch (e) {
      AppLogger.error('Auth error during sign in', e);
      return left(e.message);
    } catch (e, stackTrace) {
      AppLogger.error('Error during sign in', e, stackTrace);
      return left('Đã xảy ra lỗi khi đăng nhập');
    }
  }

  /// Sign up with email and password
  Future<Either<String, UserModel>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
    String? companyName,
  }) async {
    try {
      // Create auth user
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return left('Đăng ký thất bại');
      }

      // Create profile
      final profileData = {
        'user_id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'role': role,
        'phone': phone,
        'company_name': companyName,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final insertedProfile =
          await _client.from('profiles').insert(profileData).select().single();

      final userModel = UserModel.fromJson(insertedProfile);
      AppLogger.info('User signed up: ${userModel.email}');
      return right(userModel);
    } on AuthException catch (e) {
      AppLogger.error('Auth error during sign up', e);
      return left(e.message);
    } catch (e, stackTrace) {
      AppLogger.error('Error during sign up', e, stackTrace);
      return left('Đã xảy ra lỗi khi đăng ký');
    }
  }

  /// Sign out
  Future<Either<String, void>> signOut() async {
    try {
      await _client.auth.signOut();
      AppLogger.info('User signed out');
      return right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Error during sign out', e, stackTrace);
      return left('Đã xảy ra lỗi khi đăng xuất');
    }
  }

  /// Get current user profile
  Future<Either<String, UserModel?>> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        return right(null);
      }

      final profileData =
          await _client
              .from('profiles')
              .select()
              .eq('user_id', user.id)
              .maybeSingle();

      if (profileData == null) {
        return right(null);
      }

      return right(UserModel.fromJson(profileData));
    } catch (e, stackTrace) {
      AppLogger.error('Error getting current user', e, stackTrace);
      return left('Không thể lấy thông tin người dùng');
    }
  }

  /// Update user profile
  Future<Either<String, UserModel>> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? resumeUrl,
    String? companyName,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (resumeUrl != null) updates['resume_url'] = resumeUrl;
      if (companyName != null) updates['company_name'] = companyName;

      final updatedProfile =
          await _client
              .from('profiles')
              .update(updates)
              .eq('id', userId)
              .select()
              .single();

      final userModel = UserModel.fromJson(updatedProfile);
      AppLogger.info('Profile updated for user: $userId');
      return right(userModel);
    } catch (e, stackTrace) {
      AppLogger.error('Error updating profile', e, stackTrace);
      return left('Không thể cập nhật hồ sơ');
    }
  }
}
