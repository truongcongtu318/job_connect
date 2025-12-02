import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:job_connect/data/models/job_model.dart';

part 'recruiter_dashboard_state.freezed.dart';

/// Recruiter dashboard state
@freezed
class RecruiterDashboardState with _$RecruiterDashboardState {
  const factory RecruiterDashboardState.initial() = _Initial;
  const factory RecruiterDashboardState.loading() = _Loading;
  const factory RecruiterDashboardState.loaded({
    required List<JobModel> jobs,
    required int totalJobs,
    required int activeJobs,
    required int totalApplications,
  }) = _Loaded;
  const factory RecruiterDashboardState.error(String message) = _Error;
}
