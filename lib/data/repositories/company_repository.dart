import 'package:fpdart/fpdart.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/models/company_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for company operations
class CompanyRepository {
  final SupabaseClient _client;

  CompanyRepository(this._client);

  /// Get company by ID
  Future<Either<String, CompanyModel>> getCompanyById(String companyId) async {
    try {
      final data =
          await _client.from('companies').select().eq('id', companyId).single();

      final company = CompanyModel.fromJson(data);
      AppLogger.info('Fetched company: ${company.name}');
      return right(company);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching company', e, stackTrace);
      return left('Không thể tải thông tin công ty');
    }
  }

  /// Get company by recruiter ID (from profiles table)
  Future<Either<String, CompanyModel?>> getCompanyByRecruiterId(
    String recruiterId,
  ) async {
    try {
      // First get the user's company_id from profiles
      final profileData =
          await _client
              .from('profiles')
              .select('company_id')
              .eq('id', recruiterId)
              .maybeSingle();

      // If no profile exists, return null
      if (profileData == null) {
        AppLogger.info('Recruiter has no profile');
        return right(null);
      }

      final companyId = profileData['company_id'] as String?;

      if (companyId == null) {
        AppLogger.info('Recruiter has no company');
        return right(null);
      }

      // Then get the company details
      final companyData =
          await _client.from('companies').select().eq('id', companyId).single();

      final company = CompanyModel.fromJson(companyData);
      AppLogger.info('Fetched company for recruiter: ${company.name}');
      return right(company);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching company by recruiter', e, stackTrace);
      return left('Không thể tải thông tin công ty');
    }
  }

  /// Create a new company
  Future<Either<String, CompanyModel>> createCompany({
    required String name,
    String? description,
    String? logoUrl,
    String? website,
    String? address,
  }) async {
    try {
      final companyData = {
        'name': name,
        'description': description,
        'logo_url': logoUrl,
        'website': website,
        'address': address,
        'created_at': DateTime.now().toIso8601String(),
      };

      final data =
          await _client.from('companies').insert(companyData).select().single();

      final company = CompanyModel.fromJson(data);
      AppLogger.info('Created company: ${company.name}');
      return right(company);
    } catch (e, stackTrace) {
      AppLogger.error('Error creating company', e, stackTrace);
      return left('Không thể tạo công ty');
    }
  }

  /// Update company
  Future<Either<String, CompanyModel>> updateCompany({
    required String companyId,
    String? name,
    String? description,
    String? logoUrl,
    String? website,
    String? address,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (logoUrl != null) updateData['logo_url'] = logoUrl;
      if (website != null) updateData['website'] = website;
      if (address != null) updateData['address'] = address;

      final data =
          await _client
              .from('companies')
              .update(updateData)
              .eq('id', companyId)
              .select()
              .single();

      final company = CompanyModel.fromJson(data);
      AppLogger.info('Updated company: ${company.name}');
      return right(company);
    } catch (e, stackTrace) {
      AppLogger.error('Error updating company', e, stackTrace);
      return left('Không thể cập nhật công ty');
    }
  }

  /// Link recruiter to company (update profiles.company_id)
  /// Assumes profile already exists (created during registration)
  Future<Either<String, void>> linkRecruiterToCompany({
    required String recruiterId,
    required String companyId,
  }) async {
    try {
      final result =
          await _client
              .from('profiles')
              .update({'company_id': companyId})
              .eq('id', recruiterId) // Changed from user_id to id as requested
              .select();

      if (result.isEmpty) {
        AppLogger.error(
          'UPDATE returned empty - no profile found or RLS blocked',
        );
        return left('Không tìm thấy hồ sơ hoặc không có quyền cập nhật');
      }

      AppLogger.info(
        'Successfully linked recruiter $recruiterId to company $companyId',
      );
      AppLogger.info('Updated profile: $result');
      return right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Error linking recruiter to company', e, stackTrace);
      return left('Không thể liên kết với công ty');
    }
  }
}
