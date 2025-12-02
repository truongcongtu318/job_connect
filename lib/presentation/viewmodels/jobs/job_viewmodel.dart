import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/presentation/viewmodels/jobs/job_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_viewmodel.g.dart';

/// Job list ViewModel
@riverpod
class JobListViewModel extends _$JobListViewModel {
  @override
  JobListState build() {
    loadJobs();
    return const JobListState.initial();
  }

  String _searchQuery = '';
  int _currentPage = 0;
  final int _pageSize = 20;

  /// Load jobs from repository
  Future<void> loadJobs({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
    }

    state = const JobListState.loading();

    final jobRepo = ref.read(jobRepositoryProvider);
    final result = await jobRepo.getJobs(
      page: _currentPage,
      limit: _pageSize,
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
    );

    result.fold(
      (error) {
        AppLogger.error('Failed to load jobs: $error');
        state = JobListState.error(error);
      },
      (jobs) {
        AppLogger.info('Loaded ${jobs.length} jobs');
        state = JobListState.loaded(jobs);
      },
    );
  }

  /// Search jobs
  Future<void> searchJobs(String query) async {
    _searchQuery = query;
    _currentPage = 0;
    await loadJobs();
  }

  /// Load more jobs (pagination)
  Future<void> loadMore() async {
    state.whenOrNull(
      loaded: (currentJobs) async {
        _currentPage++;

        final jobRepo = ref.read(jobRepositoryProvider);
        final result = await jobRepo.getJobs(
          page: _currentPage,
          limit: _pageSize,
          searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
        );

        result.fold(
          (error) {
            AppLogger.error('Failed to load more jobs: $error');
            // Keep current state, just log error
          },
          (newJobs) {
            if (newJobs.isNotEmpty) {
              final allJobs = [...currentJobs, ...newJobs];
              state = JobListState.loaded(allJobs);
            }
          },
        );
      },
    );
  }

  /// Refresh jobs
  Future<void> refresh() async {
    await loadJobs(refresh: true);
  }
}

/// Job detail ViewModel
@riverpod
class JobDetailViewModel extends _$JobDetailViewModel {
  @override
  JobDetailState build(String jobId) {
    loadJob(jobId);
    return const JobDetailState.initial();
  }

  /// Load job details
  Future<void> loadJob(String jobId) async {
    state = const JobDetailState.loading();

    final jobRepo = ref.read(jobRepositoryProvider);
    final result = await jobRepo.getJobById(jobId);

    result.fold(
      (error) {
        AppLogger.error('Failed to load job: $error');
        state = JobDetailState.error(error);
      },
      (job) {
        AppLogger.info('Loaded job: ${job.title}');
        state = JobDetailState.loaded(job);
      },
    );
  }
}
