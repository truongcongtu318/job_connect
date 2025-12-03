import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/applicant_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'applicant_list_viewmodel.g.dart';

/// Applicant list ViewModel
@riverpod
class ApplicantListViewModel extends _$ApplicantListViewModel {
  @override
  ApplicantListState build(String jobId) {
    loadApplicants();
    return const ApplicantListState.initial();
  }

  /// Load applicants for job
  Future<void> loadApplicants() async {
    state = const ApplicantListState.loading();

    final appRepo = ref.read(applicationRepositoryProvider);
    final result = await appRepo.getApplicationsByJob(jobId);

    result.fold(
      (error) {
        AppLogger.error('Failed to load applicants: $error');
        state = ApplicantListState.error(error);
      },
      (applications) {
        AppLogger.info('Loaded ${applications.length} applicants');
        state = ApplicantListState.loaded(applications);
      },
    );
  }

  /// Update application status
  Future<bool> updateStatus(String applicationId, String newStatus) async {
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
        // Reload applicants
        loadApplicants();
        return true;
      },
    );
  }

  /// Refresh applicants
  Future<void> refresh() async {
    await loadApplicants();
  }
}
