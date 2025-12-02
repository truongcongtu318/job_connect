import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_rating_model.freezed.dart';
part 'ai_rating_model.g.dart';

/// AI rating model for applications
@freezed
class AiRatingModel with _$AiRatingModel {
  const factory AiRatingModel({
    required String id,
    @JsonKey(name: 'application_id') required String applicationId,
    @JsonKey(name: 'overall_score') required double overallScore,
    @JsonKey(name: 'skill_match_score') required double skillMatchScore,
    @JsonKey(name: 'experience_score') required double experienceScore,
    @JsonKey(name: 'education_score') required double educationScore,
    Map<String, dynamic>? insights, // JSONB field
    String? summary,
    @JsonKey(name: 'analyzed_at') required DateTime analyzedAt,
  }) = _AiRatingModel;

  factory AiRatingModel.fromJson(Map<String, dynamic> json) =>
      _$AiRatingModelFromJson(json);
}
