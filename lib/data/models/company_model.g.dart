// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyModelImpl _$$CompanyModelImplFromJson(Map<String, dynamic> json) =>
    _$CompanyModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$CompanyModelImplToJson(_$CompanyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logo_url': instance.logoUrl,
      'website': instance.website,
      'address': instance.address,
      'created_at': instance.createdAt.toIso8601String(),
    };
