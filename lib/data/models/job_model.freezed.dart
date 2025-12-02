// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JobModel _$JobModelFromJson(Map<String, dynamic> json) {
  return _JobModel.fromJson(json);
}

/// @nodoc
mixin _$JobModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'recruiter_id')
  String get recruiterId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get requirements => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'job_type')
  String? get jobType => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_min')
  double? get salaryMin => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_max')
  double? get salaryMax => throw _privateConstructorUsedError;
  @JsonKey(name: 'salary_currency')
  String? get salaryCurrency => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'active', 'closed', 'draft'
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this JobModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobModelCopyWith<JobModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobModelCopyWith<$Res> {
  factory $JobModelCopyWith(JobModel value, $Res Function(JobModel) then) =
      _$JobModelCopyWithImpl<$Res, JobModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'recruiter_id') String recruiterId,
    String title,
    String description,
    String requirements,
    String? location,
    @JsonKey(name: 'job_type') String? jobType,
    @JsonKey(name: 'salary_min') double? salaryMin,
    @JsonKey(name: 'salary_max') double? salaryMax,
    @JsonKey(name: 'salary_currency') String? salaryCurrency,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$JobModelCopyWithImpl<$Res, $Val extends JobModel>
    implements $JobModelCopyWith<$Res> {
  _$JobModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recruiterId = null,
    Object? title = null,
    Object? description = null,
    Object? requirements = null,
    Object? location = freezed,
    Object? jobType = freezed,
    Object? salaryMin = freezed,
    Object? salaryMax = freezed,
    Object? salaryCurrency = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            recruiterId:
                null == recruiterId
                    ? _value.recruiterId
                    : recruiterId // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            requirements:
                null == requirements
                    ? _value.requirements
                    : requirements // ignore: cast_nullable_to_non_nullable
                        as String,
            location:
                freezed == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String?,
            jobType:
                freezed == jobType
                    ? _value.jobType
                    : jobType // ignore: cast_nullable_to_non_nullable
                        as String?,
            salaryMin:
                freezed == salaryMin
                    ? _value.salaryMin
                    : salaryMin // ignore: cast_nullable_to_non_nullable
                        as double?,
            salaryMax:
                freezed == salaryMax
                    ? _value.salaryMax
                    : salaryMax // ignore: cast_nullable_to_non_nullable
                        as double?,
            salaryCurrency:
                freezed == salaryCurrency
                    ? _value.salaryCurrency
                    : salaryCurrency // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$JobModelImplCopyWith<$Res>
    implements $JobModelCopyWith<$Res> {
  factory _$$JobModelImplCopyWith(
    _$JobModelImpl value,
    $Res Function(_$JobModelImpl) then,
  ) = __$$JobModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'recruiter_id') String recruiterId,
    String title,
    String description,
    String requirements,
    String? location,
    @JsonKey(name: 'job_type') String? jobType,
    @JsonKey(name: 'salary_min') double? salaryMin,
    @JsonKey(name: 'salary_max') double? salaryMax,
    @JsonKey(name: 'salary_currency') String? salaryCurrency,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$JobModelImplCopyWithImpl<$Res>
    extends _$JobModelCopyWithImpl<$Res, _$JobModelImpl>
    implements _$$JobModelImplCopyWith<$Res> {
  __$$JobModelImplCopyWithImpl(
    _$JobModelImpl _value,
    $Res Function(_$JobModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recruiterId = null,
    Object? title = null,
    Object? description = null,
    Object? requirements = null,
    Object? location = freezed,
    Object? jobType = freezed,
    Object? salaryMin = freezed,
    Object? salaryMax = freezed,
    Object? salaryCurrency = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$JobModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        recruiterId:
            null == recruiterId
                ? _value.recruiterId
                : recruiterId // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        requirements:
            null == requirements
                ? _value.requirements
                : requirements // ignore: cast_nullable_to_non_nullable
                    as String,
        location:
            freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String?,
        jobType:
            freezed == jobType
                ? _value.jobType
                : jobType // ignore: cast_nullable_to_non_nullable
                    as String?,
        salaryMin:
            freezed == salaryMin
                ? _value.salaryMin
                : salaryMin // ignore: cast_nullable_to_non_nullable
                    as double?,
        salaryMax:
            freezed == salaryMax
                ? _value.salaryMax
                : salaryMax // ignore: cast_nullable_to_non_nullable
                    as double?,
        salaryCurrency:
            freezed == salaryCurrency
                ? _value.salaryCurrency
                : salaryCurrency // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
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
class _$JobModelImpl implements _JobModel {
  const _$JobModelImpl({
    required this.id,
    @JsonKey(name: 'recruiter_id') required this.recruiterId,
    required this.title,
    required this.description,
    required this.requirements,
    this.location,
    @JsonKey(name: 'job_type') this.jobType,
    @JsonKey(name: 'salary_min') this.salaryMin,
    @JsonKey(name: 'salary_max') this.salaryMax,
    @JsonKey(name: 'salary_currency') this.salaryCurrency,
    this.status = 'active',
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$JobModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'recruiter_id')
  final String recruiterId;
  @override
  final String title;
  @override
  final String description;
  @override
  final String requirements;
  @override
  final String? location;
  @override
  @JsonKey(name: 'job_type')
  final String? jobType;
  @override
  @JsonKey(name: 'salary_min')
  final double? salaryMin;
  @override
  @JsonKey(name: 'salary_max')
  final double? salaryMax;
  @override
  @JsonKey(name: 'salary_currency')
  final String? salaryCurrency;
  @override
  @JsonKey()
  final String status;
  // 'active', 'closed', 'draft'
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'JobModel(id: $id, recruiterId: $recruiterId, title: $title, description: $description, requirements: $requirements, location: $location, jobType: $jobType, salaryMin: $salaryMin, salaryMax: $salaryMax, salaryCurrency: $salaryCurrency, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recruiterId, recruiterId) ||
                other.recruiterId == recruiterId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.requirements, requirements) ||
                other.requirements == requirements) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.jobType, jobType) || other.jobType == jobType) &&
            (identical(other.salaryMin, salaryMin) ||
                other.salaryMin == salaryMin) &&
            (identical(other.salaryMax, salaryMax) ||
                other.salaryMax == salaryMax) &&
            (identical(other.salaryCurrency, salaryCurrency) ||
                other.salaryCurrency == salaryCurrency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    recruiterId,
    title,
    description,
    requirements,
    location,
    jobType,
    salaryMin,
    salaryMax,
    salaryCurrency,
    status,
    createdAt,
    updatedAt,
  );

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      __$$JobModelImplCopyWithImpl<_$JobModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobModelImplToJson(this);
  }
}

abstract class _JobModel implements JobModel {
  const factory _JobModel({
    required final String id,
    @JsonKey(name: 'recruiter_id') required final String recruiterId,
    required final String title,
    required final String description,
    required final String requirements,
    final String? location,
    @JsonKey(name: 'job_type') final String? jobType,
    @JsonKey(name: 'salary_min') final double? salaryMin,
    @JsonKey(name: 'salary_max') final double? salaryMax,
    @JsonKey(name: 'salary_currency') final String? salaryCurrency,
    final String status,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$JobModelImpl;

  factory _JobModel.fromJson(Map<String, dynamic> json) =
      _$JobModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'recruiter_id')
  String get recruiterId;
  @override
  String get title;
  @override
  String get description;
  @override
  String get requirements;
  @override
  String? get location;
  @override
  @JsonKey(name: 'job_type')
  String? get jobType;
  @override
  @JsonKey(name: 'salary_min')
  double? get salaryMin;
  @override
  @JsonKey(name: 'salary_max')
  double? get salaryMax;
  @override
  @JsonKey(name: 'salary_currency')
  String? get salaryCurrency;
  @override
  String get status; // 'active', 'closed', 'draft'
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
