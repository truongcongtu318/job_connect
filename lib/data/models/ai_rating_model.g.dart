// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiRatingModelImpl _$$AiRatingModelImplFromJson(Map<String, dynamic> json) =>
    _$AiRatingModelImpl(
      id: json['id'] as String,
      applicationId: json['application_id'] as String,
      overallScore: (json['overall_score'] as num).toDouble(),
      skillMatchScore: (json['skill_match_score'] as num).toDouble(),
      experienceScore: (json['experience_score'] as num).toDouble(),
      educationScore: (json['education_score'] as num).toDouble(),
      insights: json['insights'] as Map<String, dynamic>?,
      summary: json['summary'] as String?,
      analyzedAt: DateTime.parse(json['analyzed_at'] as String),
    );

Map<String, dynamic> _$$AiRatingModelImplToJson(_$AiRatingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application_id': instance.applicationId,
      'overall_score': instance.overallScore,
      'skill_match_score': instance.skillMatchScore,
      'experience_score': instance.experienceScore,
      'education_score': instance.educationScore,
      'insights': instance.insights,
      'summary': instance.summary,
      'analyzed_at': instance.analyzedAt.toIso8601String(),
    };
