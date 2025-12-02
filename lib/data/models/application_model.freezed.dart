// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) {
  return _ApplicationModel.fromJson(json);
}

/// @nodoc
mixin _$ApplicationModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'job_id')
  String get jobId => throw _privateConstructorUsedError;
  @JsonKey(name: 'candidate_id')
  String get candidateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'resume_url')
  String get resumeUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_letter')
  String? get coverLetter => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'reviewing', 'shortlisted', 'rejected', 'accepted'
  @JsonKey(name: 'applied_at')
  DateTime get appliedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ApplicationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationModelCopyWith<ApplicationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationModelCopyWith<$Res> {
  factory $ApplicationModelCopyWith(
    ApplicationModel value,
    $Res Function(ApplicationModel) then,
  ) = _$ApplicationModelCopyWithImpl<$Res, ApplicationModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'job_id') String jobId,
    @JsonKey(name: 'candidate_id') String candidateId,
    @JsonKey(name: 'resume_url') String resumeUrl,
    @JsonKey(name: 'cover_letter') String? coverLetter,
    String status,
    @JsonKey(name: 'applied_at') DateTime appliedAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$ApplicationModelCopyWithImpl<$Res, $Val extends ApplicationModel>
    implements $ApplicationModelCopyWith<$Res> {
  _$ApplicationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = null,
    Object? candidateId = null,
    Object? resumeUrl = null,
    Object? coverLetter = freezed,
    Object? status = null,
    Object? appliedAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            jobId:
                null == jobId
                    ? _value.jobId
                    : jobId // ignore: cast_nullable_to_non_nullable
                        as String,
            candidateId:
                null == candidateId
                    ? _value.candidateId
                    : candidateId // ignore: cast_nullable_to_non_nullable
                        as String,
            resumeUrl:
                null == resumeUrl
                    ? _value.resumeUrl
                    : resumeUrl // ignore: cast_nullable_to_non_nullable
                        as String,
            coverLetter:
                freezed == coverLetter
                    ? _value.coverLetter
                    : coverLetter // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            appliedAt:
                null == appliedAt
                    ? _value.appliedAt
                    : appliedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplicationModelImplCopyWith<$Res>
    implements $ApplicationModelCopyWith<$Res> {
  factory _$$ApplicationModelImplCopyWith(
    _$ApplicationModelImpl value,
    $Res Function(_$ApplicationModelImpl) then,
  ) = __$$ApplicationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'job_id') String jobId,
    @JsonKey(name: 'candidate_id') String candidateId,
    @JsonKey(name: 'resume_url') String resumeUrl,
    @JsonKey(name: 'cover_letter') String? coverLetter,
    String status,
    @JsonKey(name: 'applied_at') DateTime appliedAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$ApplicationModelImplCopyWithImpl<$Res>
    extends _$ApplicationModelCopyWithImpl<$Res, _$ApplicationModelImpl>
    implements _$$ApplicationModelImplCopyWith<$Res> {
  __$$ApplicationModelImplCopyWithImpl(
    _$ApplicationModelImpl _value,
    $Res Function(_$ApplicationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = null,
    Object? candidateId = null,
    Object? resumeUrl = null,
    Object? coverLetter = freezed,
    Object? status = null,
    Object? appliedAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ApplicationModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        jobId:
            null == jobId
                ? _value.jobId
                : jobId // ignore: cast_nullable_to_non_nullable
                    as String,
        candidateId:
            null == candidateId
                ? _value.candidateId
                : candidateId // ignore: cast_nullable_to_non_nullable
                    as String,
        resumeUrl:
            null == resumeUrl
                ? _value.resumeUrl
                : resumeUrl // ignore: cast_nullable_to_non_nullable
                    as String,
        coverLetter:
            freezed == coverLetter
                ? _value.coverLetter
                : coverLetter // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        appliedAt:
            null == appliedAt
                ? _value.appliedAt
                : appliedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationModelImpl implements _ApplicationModel {
  const _$ApplicationModelImpl({
    required this.id,
    @JsonKey(name: 'job_id') required this.jobId,
    @JsonKey(name: 'candidate_id') required this.candidateId,
    @JsonKey(name: 'resume_url') required this.resumeUrl,
    @JsonKey(name: 'cover_letter') this.coverLetter,
    this.status = 'pending',
    @JsonKey(name: 'applied_at') required this.appliedAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$ApplicationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'job_id')
  final String jobId;
  @override
  @JsonKey(name: 'candidate_id')
  final String candidateId;
  @override
  @JsonKey(name: 'resume_url')
  final String resumeUrl;
  @override
  @JsonKey(name: 'cover_letter')
  final String? coverLetter;
  @override
  @JsonKey()
  final String status;
  // 'pending', 'reviewing', 'shortlisted', 'rejected', 'accepted'
  @override
  @JsonKey(name: 'applied_at')
  final DateTime appliedAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ApplicationModel(id: $id, jobId: $jobId, candidateId: $candidateId, resumeUrl: $resumeUrl, coverLetter: $coverLetter, status: $status, appliedAt: $appliedAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.candidateId, candidateId) ||
                other.candidateId == candidateId) &&
            (identical(other.resumeUrl, resumeUrl) ||
                other.resumeUrl == resumeUrl) &&
            (identical(other.coverLetter, coverLetter) ||
                other.coverLetter == coverLetter) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    jobId,
    candidateId,
    resumeUrl,
    coverLetter,
    status,
    appliedAt,
    updatedAt,
  );

  /// Create a copy of ApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationModelImplCopyWith<_$ApplicationModelImpl> get copyWith =>
      __$$ApplicationModelImplCopyWithImpl<_$ApplicationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationModelImplToJson(this);
  }
}

abstract class _ApplicationModel implements ApplicationModel {
  const factory _ApplicationModel({
    required final String id,
    @JsonKey(name: 'job_id') required final String jobId,
    @JsonKey(name: 'candidate_id') required final String candidateId,
    @JsonKey(name: 'resume_url') required final String resumeUrl,
    @JsonKey(name: 'cover_letter') final String? coverLetter,
    final String status,
    @JsonKey(name: 'applied_at') required final DateTime appliedAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$ApplicationModelImpl;

  factory _ApplicationModel.fromJson(Map<String, dynamic> json) =
      _$ApplicationModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'job_id')
  String get jobId;
  @override
  @JsonKey(name: 'candidate_id')
  String get candidateId;
  @override
  @JsonKey(name: 'resume_url')
  String get resumeUrl;
  @override
  @JsonKey(name: 'cover_letter')
  String? get coverLetter;
  @override
  String get status; // 'pending', 'reviewing', 'shortlisted', 'rejected', 'accepted'
  @override
  @JsonKey(name: 'applied_at')
  DateTime get appliedAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationModelImplCopyWith<_$ApplicationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
