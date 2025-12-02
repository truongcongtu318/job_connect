import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:job_connect/data/models/application_model.dart';

part 'applicant_list_state.freezed.dart';

/// Applicant list state
@freezed
class ApplicantListState with _$ApplicantListState {
  const factory ApplicantListState.initial() = _Initial;
  const factory ApplicantListState.loading() = _Loading;
  const factory ApplicantListState.loaded(List<ApplicationModel> applications) =
      _Loaded;
  const factory ApplicantListState.error(String message) = _Error;
}
