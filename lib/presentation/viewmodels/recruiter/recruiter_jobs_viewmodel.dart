import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/models/job_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruiter_jobs_viewmodel.g.dart';

/// Recruiter jobs list state
sealed class RecruiterJobsState {
  const RecruiterJobsState();
}

class RecruiterJobsInitial extends RecruiterJobsState {
  const RecruiterJobsInitial();
}

class RecruiterJobsLoading extends RecruiterJobsState {
  const RecruiterJobsLoading();
}

class RecruiterJobsLoaded extends RecruiterJobsState {
  final List<JobModel> jobs;

  const RecruiterJobsLoaded(this.jobs);
}

class RecruiterJobsError extends RecruiterJobsState {
  final String message;

  const RecruiterJobsError(this.message);
}

/// Recruiter jobs ViewModel
@riverpod
class RecruiterJobsViewModel extends _$RecruiterJobsViewModel {
  @override
  RecruiterJobsState build(String recruiterId) {
    loadJobs();
    return const RecruiterJobsInitial();
  }

  /// Load jobs for recruiter
  Future<void> loadJobs() async {
    state = const RecruiterJobsLoading();

    try {
      final jobRepo = ref.read(jobRepositoryProvider);
      final result = await jobRepo.getJobsByRecruiter(recruiterId);

      result.fold(
        (error) {
          AppLogger.error('Failed to load jobs: $error');
          state = RecruiterJobsError(error);
        },
        (jobs) {
          AppLogger.info('Loaded ${jobs.length} jobs for recruiter');
          state = RecruiterJobsLoaded(jobs);
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading jobs', e, stackTrace);
      state = const RecruiterJobsError('Đã xảy ra lỗi không mong muốn');
    }
  }

  /// Refresh jobs
  Future<void> refresh() async {
    await loadJobs();
  }
}
