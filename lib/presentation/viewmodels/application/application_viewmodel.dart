import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/presentation/viewmodels/application/application_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_viewmodel.g.dart';

/// Application form ViewModel
@riverpod
class ApplicationFormViewModel extends _$ApplicationFormViewModel {
  @override
  ApplicationFormState build() {
    return const ApplicationFormState();
  }

  /// Pick resume file (PDF or DOCX)
  Future<void> pickResume() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
        allowMultiple: false,
        withData: true, // Important for web - loads bytes
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Validate file size (max 5MB)
        if (file.size > 5 * 1024 * 1024) {
          state = state.copyWith(
            resumeError: 'File quá lớn. Vui lòng chọn file dưới 5MB',
            resumeFilePath: null,
            resumeFileName: null,
            resumeBytes: null,
          );
          return;
        }

        state = state.copyWith(
          resumeFilePath: file.path, // null on web
          resumeFileName: file.name,
          resumeBytes: file.bytes, // available on web
          resumeError: null,
          generalError: null,
        );

        AppLogger.info('Resume selected: ${file.name}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error picking resume', e, stackTrace);
      state = state.copyWith(
        resumeError: 'Không thể chọn file. Vui lòng thử lại',
      );
    }
  }

  /// Set cover letter
  void setCoverLetter(String coverLetter) {
    state = state.copyWith(
      coverLetter: coverLetter,
      coverLetterError: null,
      generalError: null,
    );
  }

  /// Validate form
  bool _validateForm() {
    String? resumeError;

    if ((state.resumeFilePath == null || state.resumeFilePath!.isEmpty) &&
        state.resumeBytes == null) {
      resumeError = 'Vui lòng chọn CV của bạn';
    }

    state = state.copyWith(resumeError: resumeError);

    return resumeError == null;
  }

  /// Submit application
  Future<bool> submitApplication({
    required String jobId,
    required String candidateId,
    required String authUserId, // Auth user ID for Storage RLS
  }) async {
    if (!_validateForm()) {
      return false;
    }

    state = state.copyWith(isLoading: true, generalError: null);

    try {
      final appRepo = ref.read(applicationRepositoryProvider);

      // Upload resume first
      // On web: use bytes (path is null)
      // On mobile: use File from path
      final dynamic fileData;
      if (state.resumeBytes != null) {
        // Web platform - use bytes
        fileData = state.resumeBytes!;
      } else if (state.resumeFilePath != null) {
        // Mobile platform - use File
        fileData = File(state.resumeFilePath!);
      } else {
        state = state.copyWith(
          isLoading: false,
          generalError: 'Không thể đọc file CV',
        );
        return false;
      }

      final uploadResult = await appRepo.uploadResume(
        userId: authUserId, // Use auth user ID for RLS policy
        file: fileData,
        fileName: state.resumeFileName!,
      );

      String? resumeUrl;
      uploadResult.fold(
        (error) {
          state = state.copyWith(isLoading: false, generalError: error);
          return;
        },
        (url) {
          resumeUrl = url;
        },
      );

      if (resumeUrl == null) {
        return false;
      }

      // Create application
      final result = await appRepo.createApplication(
        jobId: jobId,
        candidateId: candidateId,
        resumeUrl: resumeUrl!,
        coverLetter: state.coverLetter.isEmpty ? null : state.coverLetter,
      );

      return result.fold(
        (error) {
          AppLogger.error('Failed to submit application: $error');
          state = state.copyWith(isLoading: false, generalError: error);
          return false;
        },
        (application) {
          AppLogger.info('Application submitted successfully');
          state = state.copyWith(isLoading: false);
          return true;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error submitting application', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        generalError: 'Đã xảy ra lỗi không mong muốn',
      );
      return false;
    }
  }

  /// Reset form
  void reset() {
    state = const ApplicationFormState();
  }
}
