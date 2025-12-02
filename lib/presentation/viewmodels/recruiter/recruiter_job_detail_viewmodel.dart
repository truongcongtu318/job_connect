import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/models/job_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruiter_job_detail_viewmodel.g.dart';
part 'recruiter_job_detail_viewmodel.freezed.dart';

@freezed
class RecruiterJobDetailState with _$RecruiterJobDetailState {
  const factory RecruiterJobDetailState.initial() = _Initial;
  const factory RecruiterJobDetailState.loading() = _Loading;
  const factory RecruiterJobDetailState.loaded({
    required JobModel job,
    required int applicantCount,
    required int newApplicantCount,
  }) = _Loaded;
  const factory RecruiterJobDetailState.error(String message) = _Error;
}

@riverpod
class RecruiterJobDetailViewModel extends _$RecruiterJobDetailViewModel {
  @override
  RecruiterJobDetailState build(String jobId) {
    loadJobDetails();
    return const RecruiterJobDetailState.initial();
  }

  Future<void> loadJobDetails() async {
    state = const RecruiterJobDetailState.loading();

    try {
      final jobRepo = ref.read(jobRepositoryProvider);
      final appRepo = ref.read(applicationRepositoryProvider);

      // Fetch job details
      final jobResult = await jobRepo.getJobById(jobId);

      await jobResult.fold(
        (error) {
          state = RecruiterJobDetailState.error(error);
        },
        (job) async {
          final appsResult = await appRepo.getApplicationsByJob(jobId);

          appsResult.fold(
            (error) {
              // If fetching apps fails, still show job but with 0 count or error?
              // For now, let's just log and show 0
              AppLogger.error('Failed to fetch apps for count: $error');
              state = RecruiterJobDetailState.loaded(
                job: job,
                applicantCount: 0,
                newApplicantCount: 0,
              );
            },
            (apps) {
              final total = apps.length;
              final newApps = apps.where((a) => a.status == 'pending').length;

              state = RecruiterJobDetailState.loaded(
                job: job,
                applicantCount: total,
                newApplicantCount: newApps,
              );
            },
          );
        },
      );
    } catch (e, stack) {
      AppLogger.error('Error loading job detail', e, stack);
      state = const RecruiterJobDetailState.error(
        'Đã xảy ra lỗi không mong muốn',
      );
    }
  }

  Future<void> toggleJobStatus(bool isActive) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    final newStatus = isActive ? 'active' : 'closed';

    // Optimistic update
    final oldJob = currentState.job;
    final updatedJob = oldJob.copyWith(status: newStatus);

    state = currentState.copyWith(job: updatedJob);

    final jobRepo = ref.read(jobRepositoryProvider);
    final result = await jobRepo.updateJob(
      jobId: updatedJob.id,
      status: newStatus,
    );

    result.fold(
      (error) {
        AppLogger.error('Failed to update job status: $error');
        // Revert on error
        state = currentState.copyWith(job: oldJob);
        // You might want to show a toast/snackbar here via a side effect,
        // but for now we just revert state.
      },
      (success) {
        AppLogger.info('Job status updated to $newStatus');
        // Success, state is already updated optimistically
      },
    );
  }

  Future<void> refresh() async {
    await loadJobDetails();
  }
}
