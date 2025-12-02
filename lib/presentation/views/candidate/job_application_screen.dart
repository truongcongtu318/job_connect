import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/data/data_sources/supabase_service.dart';
import 'package:job_connect/presentation/viewmodels/application/application_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/application/application_history_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/jobs/job_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

/// Job application screen
class JobApplicationScreen extends HookConsumerWidget {
  final String jobId;

  const JobApplicationScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobDetailState = ref.watch(jobDetailViewModelProvider(jobId));
    final formState = ref.watch(applicationFormViewModelProvider);
    final formNotifier = ref.read(applicationFormViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);

    final coverLetterController = useTextEditingController(
      text: formState.coverLetter,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Ứng tuyển')),
      body: jobDetailState.when(
        initial: () => const LoadingIndicator(),
        loading: () => const LoadingIndicator(),
        loaded: (job) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        'Công ty tuyển dụng',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (job.location != null) ...[
                        const Gap(8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const Gap(4),
                            Text(
                              job.location!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const Gap(24),

                // Resume Upload Section
                Text(
                  'Tải lên CV của bạn *',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),
                InkWell(
                  onTap: formState.isLoading ? null : formNotifier.pickResume,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            formState.resumeError != null
                                ? AppColors.error
                                : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          formState.resumeFileName != null
                              ? Icons.description
                              : Icons.upload_file,
                          color: AppColors.primary,
                          size: 32,
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formState.resumeFileName ?? 'Chọn file CV',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  fontWeight:
                                      formState.resumeFileName != null
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                'Hỗ trợ: PDF, DOCX (tối đa 5MB)',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                if (formState.resumeError != null) ...[
                  const Gap(8),
                  Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const Gap(4),
                      Text(
                        formState.resumeError!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppColors.error),
                      ),
                    ],
                  ),
                ],
                const Gap(24),

                // Cover Letter Section
                Text(
                  'Thư xin việc',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(4),
                Text(
                  'Tùy chọn - Giới thiệu bản thân và lý do ứng tuyển',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Gap(8),
                TextField(
                  controller: coverLetterController,
                  enabled: !formState.isLoading,
                  maxLines: 8,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    hintText: 'Ví dụ: Tôi rất quan tâm đến vị trí này vì...',
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onChanged: formNotifier.setCoverLetter,
                ),
                const Gap(24),

                // General Error
                if (formState.generalError != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: AppColors.error),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            formState.generalError!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                ],

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        formState.isLoading
                            ? null
                            : () async {
                              // Get auth user ID (not profile ID) for Storage RLS
                              final authUserId =
                                  SupabaseService.currentUser?.id;
                              final candidateId = authState.whenOrNull(
                                authenticated: (user) => user.id,
                              );

                              if (candidateId == null || authUserId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Vui lòng đăng nhập lại'),
                                  ),
                                );
                                return;
                              }

                              final success = await formNotifier
                                  .submitApplication(
                                    jobId: jobId,
                                    candidateId: candidateId,
                                    authUserId: authUserId, // Pass auth user ID
                                  );

                              if (success && context.mounted) {
                                // Invalidate application history to force refresh
                                ref.invalidate(
                                  applicationHistoryViewModelProvider(
                                    candidateId,
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Nộp đơn thành công!'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                                context.pop();
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        formState.isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                            : const Text('Nộp đơn ứng tuyển'),
                  ),
                ),
                const Gap(100), // Space for keyboard
              ],
            ),
          );
        },
        error:
            (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const Gap(16),
                  Text(message),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Quay lại'),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
