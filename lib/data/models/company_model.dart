import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

@freezed
class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'logo_url') String? logoUrl,
    String? website,
    String? address,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CompanyModel;

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);
}
