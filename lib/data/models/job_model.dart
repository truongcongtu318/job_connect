import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

/// Job posting model
@freezed
class JobModel with _$JobModel {
  const factory JobModel({
    required String id,
    @JsonKey(name: 'recruiter_id') required String recruiterId,
    required String title,
    required String description,
    required String requirements,
    String? location,
    @JsonKey(name: 'job_type') String? jobType,
    @JsonKey(name: 'salary_min') double? salaryMin,
    @JsonKey(name: 'salary_max') double? salaryMax,
    @JsonKey(name: 'salary_currency') String? salaryCurrency,
    @Default('active') String status, // 'active', 'closed', 'draft'
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);
}
