// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      resumeUrl: json['resume_url'] as String?,
      companyName: json['company_name'] as String?,
      companyId: json['company_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'role': instance.role,
      'full_name': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'resume_url': instance.resumeUrl,
      'company_name': instance.companyName,
      'company_id': instance.companyId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
