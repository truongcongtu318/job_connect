// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobModelImpl _$$JobModelImplFromJson(Map<String, dynamic> json) =>
    _$JobModelImpl(
      id: json['id'] as String,
      recruiterId: json['recruiter_id'] as String,
      companyId: json['company_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      requirements: json['requirements'] as String,
      benefits: json['benefits'] as String?,
      location: json['location'] as String?,
      jobType: json['job_type'] as String?,
      salaryMin: (json['salary_min'] as num?)?.toDouble(),
      salaryMax: (json['salary_max'] as num?)?.toDouble(),
      salaryCurrency: json['salary_currency'] as String? ?? 'VND',
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] == null
              ? null
              : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$JobModelImplToJson(_$JobModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recruiter_id': instance.recruiterId,
      'company_id': instance.companyId,
      'title': instance.title,
      'description': instance.description,
      'requirements': instance.requirements,
      'benefits': instance.benefits,
      'location': instance.location,
      'job_type': instance.jobType,
      'salary_min': instance.salaryMin,
      'salary_max': instance.salaryMax,
      'salary_currency': instance.salaryCurrency,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
