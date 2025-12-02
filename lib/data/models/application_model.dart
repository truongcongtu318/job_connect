import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_model.freezed.dart';
part 'application_model.g.dart';

/// Job application model
@freezed
class ApplicationModel with _$ApplicationModel {
  const factory ApplicationModel({
    required String id,
    @JsonKey(name: 'job_id') required String jobId,
    @JsonKey(name: 'candidate_id') required String candidateId,
    @JsonKey(name: 'resume_url') required String resumeUrl,
    @JsonKey(name: 'cover_letter') String? coverLetter,
    @Default('pending')
    String
    status, // 'pending', 'reviewing', 'shortlisted', 'rejected', 'accepted'
    @JsonKey(name: 'applied_at') required DateTime appliedAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ApplicationModel;

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationModelFromJson(json);
}
