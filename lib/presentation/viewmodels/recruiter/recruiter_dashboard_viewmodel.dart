import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/recruiter_dashboard_state.dart';

part 'recruiter_dashboard_viewmodel.g.dart';

/// Recruiter dashboard ViewModel
@riverpod
class RecruiterDashboardViewModel extends _$RecruiterDashboardViewModel {
  @override
  RecruiterDashboardState build(String recruiterId) {
    loadDashboard();
    return const RecruiterDashboardState.initial();
  }

  /// Load dashboard data
  Future<void> loadDashboard() async {
    state = const RecruiterDashboardState.loading();

    try {
      final jobRepo = ref.read(jobRepositoryProvider);
      final appRepo = ref.read(applicationRepositoryProvider);

      // Load jobs for recruiter
      final jobsResult = await jobRepo.getJobsByRecruiter(recruiterId);

      await jobsResult.fold(
        (error) async {
          AppLogger.error('Failed to load jobs: $error');
          state = RecruiterDashboardState.error(error);
        },
        (jobs) async {
          // Calculate statistics
          final totalJobs = jobs.length;
          final activeJobs = jobs.where((job) => job.status == 'active').length;

          // Count total applications for all jobs
          int totalApplications = 0;
          for (final job in jobs) {
            final appsResult = await appRepo.getApplicationsByJob(job.id);
            appsResult.fold(
              (error) => AppLogger.error('Failed to load applications: $error'),
              (apps) => totalApplications += apps.length,
            );
          }

          AppLogger.info(
            'Loaded dashboard: $totalJobs jobs, $totalApplications applications',
          );
          state = RecruiterDashboardState.loaded(
            jobs: jobs,
            totalJobs: totalJobs,
            activeJobs: activeJobs,
            totalApplications: totalApplications,
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading dashboard', e, stackTrace);
      state = const RecruiterDashboardState.error(
        'Đã xảy ra lỗi không mong muốn',
      );
    }
  }

  /// Refresh dashboard
  Future<void> refresh() async {
    await loadDashboard();
  }
}
