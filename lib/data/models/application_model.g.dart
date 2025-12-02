// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationModelImpl _$$ApplicationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ApplicationModelImpl(
  id: json['id'] as String,
  jobId: json['job_id'] as String,
  candidateId: json['candidate_id'] as String,
  resumeUrl: json['resume_url'] as String,
  coverLetter: json['cover_letter'] as String?,
  status: json['status'] as String? ?? 'pending',
  appliedAt: DateTime.parse(json['applied_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$ApplicationModelImplToJson(
  _$ApplicationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'job_id': instance.jobId,
  'candidate_id': instance.candidateId,
  'resume_url': instance.resumeUrl,
  'cover_letter': instance.coverLetter,
  'status': instance.status,
  'applied_at': instance.appliedAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
