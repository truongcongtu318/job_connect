import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/utils/extensions.dart';
import 'package:job_connect/presentation/viewmodels/jobs/job_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

/// Job detail screen
class JobDetailScreen extends HookConsumerWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobDetailState = ref.watch(jobDetailViewModelProvider(jobId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chi tiết công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Add to favorites
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: Share job
            },
          ),
        ],
      ),
      body: jobDetailState.when(
        initial: () => const LoadingIndicator(),
        loading: () => const LoadingIndicator(),
        loaded: (job) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company header
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Company logo
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.business,
                              color: AppColors.primary,
                              size: 40,
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Gap(4),
                                Text(
                                  'Công ty tuyển dụng',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      // Salary
                      if (job.salaryMin != null || job.salaryMax != null)
                        Row(
                          children: [
                            Icon(
                              Icons.payments_outlined,
                              size: 20,
                              color: AppColors.success,
                            ),
                            const Gap(8),
                            Text(
                              _getSalaryText(job),
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Mức lương: Thỏa thuận',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const Gap(12),
                      // Location
                      if (job.location != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            const Gap(8),
                            Expanded(
                              child: Text(
                                job.location!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      const Gap(8),
                      // Job type
                      if (job.jobType != null)
                        Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            const Gap(8),
                            Text(
                              job.jobType!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const Gap(12),

                // Job description
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mô tả công việc',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(12),
                      Text(
                        job.description,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.6),
                      ),
                    ],
                  ),
                ),
                const Gap(12),

                // Job requirements
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yêu cầu công việc',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(12),
                      Text(
                        job.requirements,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.6),
                      ),
                    ],
                  ),
                ),
                const Gap(100), // Space for bottom button
              ],
            ),
          );
        },
        error:
            (message) => ErrorDisplay(
              message: message,
              onRetry: () {
                ref.invalidate(jobDetailViewModelProvider(jobId));
              },
            ),
      ),
      bottomSheet: jobDetailState.maybeWhen(
        loaded:
            (job) => Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to application screen
                    context.go('/jobs/$jobId/apply');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Ứng tuyển ngay'),
                ),
              ),
            ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  String _getSalaryText(dynamic job) {
    final salaryMin = job.salaryMin as num?;
    final salaryMax = job.salaryMax as num?;

    if (salaryMin != null && salaryMax != null) {
      return '${salaryMin.toVnd()} - ${salaryMax.toVnd()}';
    } else if (salaryMin != null) {
      return 'Từ ${salaryMin.toVnd()}';
    } else if (salaryMax != null) {
      return 'Lên đến ${salaryMax.toVnd()}';
    }
    return 'Thỏa thuận';
  }
}
