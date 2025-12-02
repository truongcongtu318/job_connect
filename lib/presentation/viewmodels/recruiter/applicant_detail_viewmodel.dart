import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/applicant_detail_state.dart';

part 'applicant_detail_viewmodel.g.dart';

@riverpod
class ApplicantDetailViewModel extends _$ApplicantDetailViewModel {
  @override
  ApplicantDetailState build(String applicationId) {
    loadApplicantDetails();
    return const ApplicantDetailState.initial();
  }

  /// Load applicant details
  Future<void> loadApplicantDetails() async {
    state = const ApplicantDetailState.loading();

    try {
      final appRepo = ref.read(applicationRepositoryProvider);
      final profileRepo = ref.read(profileRepositoryProvider);
      final jobRepo = ref.read(jobRepositoryProvider);

      // Get application
      final appResult = await appRepo.getApplicationById(applicationId);

      await appResult.fold(
        (error) {
          state = ApplicantDetailState.error(error);
        },
        (application) async {
          // Get candidate profile
          final profileResult = await profileRepo.getProfileById(
            application.candidateId,
          );

          await profileResult.fold(
            (error) {
              state = ApplicantDetailState.error(
                'Không thể tải thông tin ứng viên',
              );
            },
            (candidate) async {
              // Get job details
              final jobResult = await jobRepo.getJobById(application.jobId);

              jobResult.fold(
                (error) {
                  state = ApplicantDetailState.error(
                    'Không thể tải thông tin công việc',
                  );
                },
                (job) {
                  state = ApplicantDetailState.loaded(
                    application: application,
                    candidate: candidate,
                    job: job,
                  );
                },
              );
            },
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading applicant details', e, stackTrace);
      state = const ApplicantDetailState.error('Đã xảy ra lỗi không mong muốn');
    }
  }

  /// Update application status
  Future<bool> updateStatus(String newStatus) async {
    final appRepo = ref.read(applicationRepositoryProvider);
    final result = await appRepo.updateApplicationStatus(
      applicationId: applicationId,
      status: newStatus,
    );

    return result.fold(
      (error) {
        AppLogger.error('Failed to update status: $error');
        return false;
      },
      (_) {
        AppLogger.info('Updated application status to $newStatus');
        // Reload details
        loadApplicantDetails();
        return true;
      },
    );
  }

  /// Accept application
  Future<bool> acceptApplication() async {
    return await updateStatus('accepted');
  }

  /// Reject application
  Future<bool> rejectApplication() async {
    return await updateStatus('rejected');
  }

  /// Refresh
  Future<void> refresh() async {
    await loadApplicantDetails();
  }
}
