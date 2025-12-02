import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:job_connect/data/models/job_model.dart';

part 'job_state.freezed.dart';

/// Job list state
@freezed
class JobListState with _$JobListState {
  const factory JobListState.initial() = _Initial;
  const factory JobListState.loading() = _Loading;
  const factory JobListState.loaded(List<JobModel> jobs) = _Loaded;
  const factory JobListState.error(String message) = _Error;
}

/// Job detail state
@freezed
class JobDetailState with _$JobDetailState {
  const factory JobDetailState.initial() = _JobDetailInitial;
  const factory JobDetailState.loading() = _JobDetailLoading;
  const factory JobDetailState.loaded(JobModel job) = _JobDetailLoaded;
  const factory JobDetailState.error(String message) = _JobDetailError;
}
