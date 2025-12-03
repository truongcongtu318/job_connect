import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/company_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

/// Company profile screen for recruiters
class CompanyProfileScreen extends HookConsumerWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final recruiterId = authState.whenOrNull(authenticated: (user) => user.id);

    if (recruiterId == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('Hồ sơ công ty'),
          backgroundColor: AppColors.white,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        body: const Center(child: Text('Vui lòng đăng nhập')),
      );
    }

    final companyState = ref.watch(companyViewModelProvider(recruiterId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          companyState is CompanyLoaded && companyState.company != null
              ? 'Cập nhật hồ sơ công ty'
              : 'Tạo hồ sơ công ty',
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: switch (companyState) {
        CompanyInitial() => const LoadingIndicator(),
        CompanyLoading() => const LoadingIndicator(),
        CompanyError(:final message) => ErrorDisplay(
          message: message,
          onRetry: () {
            ref.invalidate(companyViewModelProvider(recruiterId));
          },
        ),
        CompanyLoaded(:final company) => _CompanyForm(
          company: company,
          recruiterId: recruiterId,
        ),
      },
    );
  }
}

class _CompanyForm extends HookConsumerWidget {
  final dynamic company;
  final String recruiterId;

  const _CompanyForm({required this.company, required this.recruiterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = company != null;

    final nameController = useTextEditingController(text: company?.name ?? '');
    final descriptionController = useTextEditingController(
      text: company?.description ?? '',
    );
    final logoUrlController = useTextEditingController(
      text: company?.logoUrl ?? '',
    );
    final websiteController = useTextEditingController(
      text: company?.website ?? '',
    );
    final addressController = useTextEditingController(
      text: company?.address ?? '',
    );

    final isLoading = useState(false);

    Future<void> handleSubmit() async {
      // Validation
      if (nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập tên công ty')),
        );
        return;
      }

      isLoading.value = true;

      try {
        final viewModel = ref.read(
          companyViewModelProvider(recruiterId).notifier,
        );
        final bool success;

        if (isEditing) {
          // Update existing company
          success = await viewModel.updateCompany(
            companyId: company!.id,
            name: nameController.text.trim(),
            description:
                descriptionController.text.trim().isNotEmpty
                    ? descriptionController.text.trim()
                    : null,
            logoUrl:
                logoUrlController.text.trim().isNotEmpty
                    ? logoUrlController.text.trim()
                    : null,
            website:
                websiteController.text.trim().isNotEmpty
                    ? websiteController.text.trim()
                    : null,
            address:
                addressController.text.trim().isNotEmpty
                    ? addressController.text.trim()
                    : null,
          );
        } else {
          // Create new company
          success = await viewModel.createCompany(
            name: nameController.text.trim(),
            description:
                descriptionController.text.trim().isNotEmpty
                    ? descriptionController.text.trim()
                    : null,
            logoUrl:
                logoUrlController.text.trim().isNotEmpty
                    ? logoUrlController.text.trim()
                    : null,
            website:
                websiteController.text.trim().isNotEmpty
                    ? websiteController.text.trim()
                    : null,
            address:
                addressController.text.trim().isNotEmpty
                    ? addressController.text.trim()
                    : null,
          );
        }

        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing
                    ? 'Cập nhật thông tin thành công!'
                    : 'Tạo hồ sơ công ty thành công!',
              ),
            ),
          );
          context.pop();
        }
      } finally {
        isLoading.value = false;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Name
          Text(
            'Tên công ty *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(8),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'VD: Công ty TNHH ABC',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Gap(20),

          // Description
          Text(
            'Mô tả công ty',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(8),
          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Giới thiệu về công ty...',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Gap(20),

          // Logo URL
          Text(
            'Logo công ty (URL)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(8),
          TextField(
            controller: logoUrlController,
            decoration: InputDecoration(
              hintText: 'https://example.com/logo.png',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Gap(20),

          // Website
          Text(
            'Website',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(8),
          TextField(
            controller: websiteController,
            decoration: InputDecoration(
              hintText: 'https://example.com',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Gap(20),

          // Address
          Text(
            'Địa chỉ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(8),
          TextField(
            controller: addressController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Địa chỉ văn phòng công ty',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Gap(32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading.value ? null : handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  isLoading.value
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text(
                        isEditing ? 'Cập nhật thông tin' : 'Tạo hồ sơ công ty',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
          const Gap(20),
        ],
      ),
    );
  }
}
