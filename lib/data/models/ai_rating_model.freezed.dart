// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_rating_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AiRatingModel _$AiRatingModelFromJson(Map<String, dynamic> json) {
  return _AiRatingModel.fromJson(json);
}

/// @nodoc
mixin _$AiRatingModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'application_id')
  String get applicationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'overall_score')
  double get overallScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'skill_match_score')
  double get skillMatchScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'experience_score')
  double get experienceScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'education_score')
  double get educationScore => throw _privateConstructorUsedError;
  Map<String, dynamic>? get insights =>
      throw _privateConstructorUsedError; // JSONB field
  String? get summary => throw _privateConstructorUsedError;
  @JsonKey(name: 'analyzed_at')
  DateTime get analyzedAt => throw _privateConstructorUsedError;

  /// Serializes this AiRatingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiRatingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiRatingModelCopyWith<AiRatingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiRatingModelCopyWith<$Res> {
  factory $AiRatingModelCopyWith(
    AiRatingModel value,
    $Res Function(AiRatingModel) then,
  ) = _$AiRatingModelCopyWithImpl<$Res, AiRatingModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'application_id') String applicationId,
    @JsonKey(name: 'overall_score') double overallScore,
    @JsonKey(name: 'skill_match_score') double skillMatchScore,
    @JsonKey(name: 'experience_score') double experienceScore,
    @JsonKey(name: 'education_score') double educationScore,
    Map<String, dynamic>? insights,
    String? summary,
    @JsonKey(name: 'analyzed_at') DateTime analyzedAt,
  });
}

/// @nodoc
class _$AiRatingModelCopyWithImpl<$Res, $Val extends AiRatingModel>
    implements $AiRatingModelCopyWith<$Res> {
  _$AiRatingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiRatingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicationId = null,
    Object? overallScore = null,
    Object? skillMatchScore = null,
    Object? experienceScore = null,
    Object? educationScore = null,
    Object? insights = freezed,
    Object? summary = freezed,
    Object? analyzedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            applicationId:
                null == applicationId
                    ? _value.applicationId
                    : applicationId // ignore: cast_nullable_to_non_nullable
                        as String,
            overallScore:
                null == overallScore
                    ? _value.overallScore
                    : overallScore // ignore: cast_nullable_to_non_nullable
                        as double,
            skillMatchScore:
                null == skillMatchScore
                    ? _value.skillMatchScore
                    : skillMatchScore // ignore: cast_nullable_to_non_nullable
                        as double,
            experienceScore:
                null == experienceScore
                    ? _value.experienceScore
                    : experienceScore // ignore: cast_nullable_to_non_nullable
                        as double,
            educationScore:
                null == educationScore
                    ? _value.educationScore
                    : educationScore // ignore: cast_nullable_to_non_nullable
                        as double,
            insights:
                freezed == insights
                    ? _value.insights
                    : insights // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            summary:
                freezed == summary
                    ? _value.summary
                    : summary // ignore: cast_nullable_to_non_nullable
                        as String?,
            analyzedAt:
                null == analyzedAt
                    ? _value.analyzedAt
                    : analyzedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AiRatingModelImplCopyWith<$Res>
    implements $AiRatingModelCopyWith<$Res> {
  factory _$$AiRatingModelImplCopyWith(
    _$AiRatingModelImpl value,
    $Res Function(_$AiRatingModelImpl) then,
  ) = __$$AiRatingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'application_id') String applicationId,
    @JsonKey(name: 'overall_score') double overallScore,
    @JsonKey(name: 'skill_match_score') double skillMatchScore,
    @JsonKey(name: 'experience_score') double experienceScore,
    @JsonKey(name: 'education_score') double educationScore,
    Map<String, dynamic>? insights,
    String? summary,
    @JsonKey(name: 'analyzed_at') DateTime analyzedAt,
  });
}

/// @nodoc
class __$$AiRatingModelImplCopyWithImpl<$Res>
    extends _$AiRatingModelCopyWithImpl<$Res, _$AiRatingModelImpl>
    implements _$$AiRatingModelImplCopyWith<$Res> {
  __$$AiRatingModelImplCopyWithImpl(
    _$AiRatingModelImpl _value,
    $Res Function(_$AiRatingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiRatingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicationId = null,
    Object? overallScore = null,
    Object? skillMatchScore = null,
    Object? experienceScore = null,
    Object? educationScore = null,
    Object? insights = freezed,
    Object? summary = freezed,
    Object? analyzedAt = null,
  }) {
    return _then(
      _$AiRatingModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        applicationId:
            null == applicationId
                ? _value.applicationId
                : applicationId // ignore: cast_nullable_to_non_nullable
                    as String,
        overallScore:
            null == overallScore
                ? _value.overallScore
                : overallScore // ignore: cast_nullable_to_non_nullable
                    as double,
        skillMatchScore:
            null == skillMatchScore
                ? _value.skillMatchScore
                : skillMatchScore // ignore: cast_nullable_to_non_nullable
                    as double,
        experienceScore:
            null == experienceScore
                ? _value.experienceScore
                : experienceScore // ignore: cast_nullable_to_non_nullable
                    as double,
        educationScore:
            null == educationScore
                ? _value.educationScore
                : educationScore // ignore: cast_nullable_to_non_nullable
                    as double,
        insights:
            freezed == insights
                ? _value._insights
                : insights // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        summary:
            freezed == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                    as String?,
        analyzedAt:
            null == analyzedAt
                ? _value.analyzedAt
                : analyzedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AiRatingModelImpl implements _AiRatingModel {
  const _$AiRatingModelImpl({
    required this.id,
    @JsonKey(name: 'application_id') required this.applicationId,
    @JsonKey(name: 'overall_score') required this.overallScore,
    @JsonKey(name: 'skill_match_score') required this.skillMatchScore,
    @JsonKey(name: 'experience_score') required this.experienceScore,
    @JsonKey(name: 'education_score') required this.educationScore,
    final Map<String, dynamic>? insights,
    this.summary,
    @JsonKey(name: 'analyzed_at') required this.analyzedAt,
  }) : _insights = insights;

  factory _$AiRatingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiRatingModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'application_id')
  final String applicationId;
  @override
  @JsonKey(name: 'overall_score')
  final double overallScore;
  @override
  @JsonKey(name: 'skill_match_score')
  final double skillMatchScore;
  @override
  @JsonKey(name: 'experience_score')
  final double experienceScore;
  @override
  @JsonKey(name: 'education_score')
  final double educationScore;
  final Map<String, dynamic>? _insights;
  @override
  Map<String, dynamic>? get insights {
    final value = _insights;
    if (value == null) return null;
    if (_insights is EqualUnmodifiableMapView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // JSONB field
  @override
  final String? summary;
  @override
  @JsonKey(name: 'analyzed_at')
  final DateTime analyzedAt;

  @override
  String toString() {
    return 'AiRatingModel(id: $id, applicationId: $applicationId, overallScore: $overallScore, skillMatchScore: $skillMatchScore, experienceScore: $experienceScore, educationScore: $educationScore, insights: $insights, summary: $summary, analyzedAt: $analyzedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiRatingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.overallScore, overallScore) ||
                other.overallScore == overallScore) &&
            (identical(other.skillMatchScore, skillMatchScore) ||
                other.skillMatchScore == skillMatchScore) &&
            (identical(other.experienceScore, experienceScore) ||
                other.experienceScore == experienceScore) &&
            (identical(other.educationScore, educationScore) ||
                other.educationScore == educationScore) &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.analyzedAt, analyzedAt) ||
                other.analyzedAt == analyzedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    applicationId,
    overallScore,
    skillMatchScore,
    experienceScore,
    educationScore,
    const DeepCollectionEquality().hash(_insights),
    summary,
    analyzedAt,
  );

  /// Create a copy of AiRatingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiRatingModelImplCopyWith<_$AiRatingModelImpl> get copyWith =>
      __$$AiRatingModelImplCopyWithImpl<_$AiRatingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiRatingModelImplToJson(this);
  }
}

abstract class _AiRatingModel implements AiRatingModel {
  const factory _AiRatingModel({
    required final String id,
    @JsonKey(name: 'application_id') required final String applicationId,
    @JsonKey(name: 'overall_score') required final double overallScore,
    @JsonKey(name: 'skill_match_score') required final double skillMatchScore,
    @JsonKey(name: 'experience_score') required final double experienceScore,
    @JsonKey(name: 'education_score') required final double educationScore,
    final Map<String, dynamic>? insights,
    final String? summary,
    @JsonKey(name: 'analyzed_at') required final DateTime analyzedAt,
  }) = _$AiRatingModelImpl;

  factory _AiRatingModel.fromJson(Map<String, dynamic> json) =
      _$AiRatingModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'application_id')
  String get applicationId;
  @override
  @JsonKey(name: 'overall_score')
  double get overallScore;
  @override
  @JsonKey(name: 'skill_match_score')
  double get skillMatchScore;
  @override
  @JsonKey(name: 'experience_score')
  double get experienceScore;
  @override
  @JsonKey(name: 'education_score')
  double get educationScore;
  @override
  Map<String, dynamic>? get insights; // JSONB field
  @override
  String? get summary;
  @override
  @JsonKey(name: 'analyzed_at')
  DateTime get analyzedAt;

  /// Create a copy of AiRatingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiRatingModelImplCopyWith<_$AiRatingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
