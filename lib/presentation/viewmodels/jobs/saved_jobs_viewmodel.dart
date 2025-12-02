import 'package:job_connect/data/models/job_model.dart';
import 'package:job_connect/data/repositories/job_repository.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'saved_jobs_viewmodel.g.dart';

@riverpod
class SavedJobsViewModel extends _$SavedJobsViewModel {
  late final JobRepository _repository;

  @override
  Future<List<JobModel>> build() async {
    _repository = JobRepository();
    return _fetchSavedJobs();
  }

  Future<List<JobModel>> _fetchSavedJobs() async {
    final user = ref
        .read(authViewModelProvider)
        .mapOrNull(authenticated: (state) => state.user);
    if (user == null) return [];

    final result = await _repository.getSavedJobs(user.userId);
    return result.fold((error) => throw Exception(error), (jobs) => jobs);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSavedJobs());
  }

  Future<void> toggleSaveJob(String jobId) async {
    final user = ref
        .read(authViewModelProvider)
        .mapOrNull(authenticated: (state) => state.user);
    if (user == null) return;

    final currentJobs = state.value ?? [];
    final isSaved = currentJobs.any((job) => job.id == jobId);

    // Optimistic update
    if (isSaved) {
      state = AsyncValue.data(
        currentJobs.where((job) => job.id != jobId).toList(),
      );

      final result = await _repository.unsaveJob(user.userId, jobId);
      result.fold((error) {
        // Revert if failed
        refresh();
      }, (_) {});
    } else {
      final result = await _repository.saveJob(user.userId, jobId);
      result.fold(
        (error) {}, // Handle error
        (_) => refresh(), // Refresh to get the new list
      );
    }
  }

  // Method to check if a job is saved (synchronously from state)
  bool isJobSaved(String jobId) {
    return state.value?.any((job) => job.id == jobId) ?? false;
  }
}
