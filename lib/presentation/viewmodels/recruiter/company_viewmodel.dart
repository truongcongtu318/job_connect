import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/models/company_model.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'company_viewmodel.g.dart';

/// Company state
sealed class CompanyState {
  const CompanyState();
}

class CompanyInitial extends CompanyState {
  const CompanyInitial();
}

class CompanyLoading extends CompanyState {
  const CompanyLoading();
}

class CompanyLoaded extends CompanyState {
  final CompanyModel? company;

  const CompanyLoaded(this.company);
}

class CompanyError extends CompanyState {
  final String message;

  const CompanyError(this.message);
}

/// Company ViewModel
@riverpod
class CompanyViewModel extends _$CompanyViewModel {
  @override
  CompanyState build(String recruiterId) {
    loadCompany();
    return const CompanyInitial();
  }

  /// Load company for recruiter
  Future<void> loadCompany() async {
    state = const CompanyLoading();

    try {
      final companyRepo = ref.read(companyRepositoryProvider);
      final result = await companyRepo.getCompanyByRecruiterId(recruiterId);

      result.fold(
        (error) {
          AppLogger.error('Failed to load company: $error');
          state = CompanyError(error);
        },
        (company) {
          AppLogger.info('Loaded company: ${company?.name ?? "none"}');
          state = CompanyLoaded(company);
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error loading company', e, stackTrace);
      state = const CompanyError('Đã xảy ra lỗi không mong muốn');
    }
  }

  /// Create company
  Future<bool> createCompany({
    required String name,
    String? description,
    String? logoUrl,
    String? website,
    String? address,
  }) async {
    try {
      final companyRepo = ref.read(companyRepositoryProvider);

      // Create company
      final createResult = await companyRepo.createCompany(
        name: name,
        description: description,
        logoUrl: logoUrl,
        website: website,
        address: address,
      );

      return await createResult.fold(
        (error) {
          AppLogger.error('Failed to create company: $error');
          state = CompanyError(error);
          return false;
        },
        (company) async {
          // Link recruiter to company
          final linkResult = await companyRepo.linkRecruiterToCompany(
            recruiterId: recruiterId,
            companyId: company.id,
          );

          return linkResult.fold(
            (error) {
              AppLogger.error('Failed to link recruiter to company: $error');
              state = CompanyError(error);
              return false;
            },
            (_) {
              AppLogger.info('Created and linked company: ${company.name}');
              state = CompanyLoaded(company);

              // Refresh auth state to update company_id in user model
              ref.read(authViewModelProvider.notifier).checkAuthState();

              return true;
            },
          );
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error creating company', e, stackTrace);
      state = const CompanyError('Đã xảy ra lỗi không mong muốn');
      return false;
    }
  }

  /// Update company
  Future<bool> updateCompany({
    required String companyId,
    String? name,
    String? description,
    String? logoUrl,
    String? website,
    String? address,
  }) async {
    try {
      final companyRepo = ref.read(companyRepositoryProvider);
      final result = await companyRepo.updateCompany(
        companyId: companyId,
        name: name,
        description: description,
        logoUrl: logoUrl,
        website: website,
        address: address,
      );

      return result.fold(
        (error) {
          AppLogger.error('Failed to update company: $error');
          state = CompanyError(error);
          return false;
        },
        (company) {
          AppLogger.info('Updated company: ${company.name}');
          state = CompanyLoaded(company);
          return true;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error updating company', e, stackTrace);
      state = const CompanyError('Đã xảy ra lỗi không mong muốn');
      return false;
    }
  }

  /// Refresh company
  Future<void> refresh() async {
    await loadCompany();
  }
}
