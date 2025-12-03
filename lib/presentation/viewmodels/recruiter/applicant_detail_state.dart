import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:job_connect/data/models/application_model.dart';
import 'package:job_connect/data/models/job_model.dart';
import 'package:job_connect/data/models/profile_model.dart';

part 'applicant_detail_state.freezed.dart';

@freezed
class ApplicantDetailState with _$ApplicantDetailState {
  const factory ApplicantDetailState.initial() = _Initial;
  const factory ApplicantDetailState.loading() = _Loading;
  const factory ApplicantDetailState.loaded({
    required ApplicationModel application,
    required ProfileModel candidate,
    required JobModel job,
  }) = _Loaded;
  const factory ApplicantDetailState.error(String message) = _Error;
}
