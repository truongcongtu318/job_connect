import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/presentation/viewmodels/application/application_history_state.dart';

part 'application_history_viewmodel.g.dart';

/// Application history ViewModel
@riverpod
class ApplicationHistoryViewModel extends _$ApplicationHistoryViewModel {
  @override
  ApplicationHistoryState build(String candidateId) {
    loadApplications();
    return const ApplicationHistoryState.initial();
  }

  /// Load applications for candidate
  Future<void> loadApplications() async {
    state = const ApplicationHistoryState.loading();

    final appRepo = ref.read(applicationRepositoryProvider);
    final result = await appRepo.getApplicationsByCandidate(candidateId);

    result.fold(
      (error) {
        AppLogger.error('Failed to load applications: $error');
        state = ApplicationHistoryState.error(error);
      },
      (applications) {
        AppLogger.info('Loaded ${applications.length} applications');
        state = ApplicationHistoryState.loaded(applications);
      },
    );
  }

  /// Refresh applications
  Future<void> refresh() async {
    await loadApplications();
  }
}
