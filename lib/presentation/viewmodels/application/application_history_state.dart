import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:job_connect/data/models/application_model.dart';

part 'application_history_state.freezed.dart';

/// Application history state
@freezed
class ApplicationHistoryState with _$ApplicationHistoryState {
  const factory ApplicationHistoryState.initial() = _Initial;
  const factory ApplicationHistoryState.loading() = _Loading;
  const factory ApplicationHistoryState.loaded(
    List<ApplicationModel> applications,
  ) = _Loaded;
  const factory ApplicationHistoryState.error(String message) = _Error;
}
