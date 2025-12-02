import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  FutureOr<void> build() {
    // Initial state is void (idle)
  }

  /// Upload resume
  Future<void> uploadResume() async {
    state = const AsyncValue.loading();

    try {
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true, // Needed for web/memory access if not using path
      );

      if (result == null || result.files.isEmpty) {
        state = const AsyncValue.data(null);
        return;
      }

      final file = result.files.first;

      // Get current user ID
      final authState = ref.read(authViewModelProvider);
      final userId = authState.whenOrNull(authenticated: (user) => user.id);

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final profileRepo = ref.read(profileRepositoryProvider);

      // Use bytes for upload
      final uploadResult = await profileRepo.uploadResume(
        userId: userId,
        file: file.bytes!, // Assuming bytes are available
        fileName: file.name,
      );

      await uploadResult.fold(
        (error) async {
          AppLogger.error('Failed to upload resume: $error');
          state = AsyncValue.error(error, StackTrace.current);
        },
        (url) async {
          AppLogger.info('Resume uploaded successfully');
          // Refresh auth state to get updated profile with resume URL
          await ref.read(authViewModelProvider.notifier).checkAuthState();
          state = const AsyncValue.data(null);
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error in uploadResume', e, stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Delete resume (set url to null)
  Future<void> deleteResume() async {
    state = const AsyncValue.loading();

    try {
      final authState = ref.read(authViewModelProvider);
      final userId = authState.whenOrNull(authenticated: (user) => user.id);

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final profileRepo = ref.read(profileRepositoryProvider);

      final result = await profileRepo.updateProfile(
        profileId: userId,
        updates: {'resume_url': null},
      );

      await result.fold(
        (error) async {
          state = AsyncValue.error(error, StackTrace.current);
        },
        (_) async {
          // Refresh auth state
          await ref.read(authViewModelProvider.notifier).checkAuthState();
          state = const AsyncValue.data(null);
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Update profile information
  Future<bool> updateProfile({
    required String fullName,
    String? phoneNumber,
  }) async {
    state = const AsyncValue.loading();

    try {
      final authState = ref.read(authViewModelProvider);
      final userId = authState.whenOrNull(authenticated: (user) => user.id);

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final profileRepo = ref.read(profileRepositoryProvider);

      final result = await profileRepo.updateProfile(
        profileId: userId,
        updates: {'full_name': fullName, 'phone': phoneNumber},
      );

      return await result.fold(
        (error) async {
          state = AsyncValue.error(error, StackTrace.current);
          return false;
        },
        (_) async {
          // Refresh auth state to get updated profile
          await ref.read(authViewModelProvider.notifier).checkAuthState();
          state = const AsyncValue.data(null);
          return true;
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// Upload avatar
  Future<void> uploadAvatar() async {
    state = const AsyncValue.loading();

    try {
      // Pick image using ImagePicker
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024, // Optimize size
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final bytes = await image.readAsBytes();
      final fileName = image.name;

      // Get current user
      final authState = ref.read(authViewModelProvider);
      final user = authState.whenOrNull(authenticated: (user) => user);

      if (user == null) {
        throw Exception('User not authenticated');
      }

      final profileRepo = ref.read(profileRepositoryProvider);

      final uploadResult = await profileRepo.uploadAvatar(
        authUserId: user.userId, // Auth ID for Storage RLS
        profileId: user.id, // Profile ID for DB update
        file: bytes,
        fileName: fileName,
      );

      await uploadResult.fold(
        (error) async {
          AppLogger.error('Failed to upload avatar: $error');
          state = AsyncValue.error(error, StackTrace.current);
        },
        (url) async {
          AppLogger.info('Avatar uploaded successfully');
          await ref.read(authViewModelProvider.notifier).checkAuthState();
          state = const AsyncValue.data(null);
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error in uploadAvatar', e, stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
