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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobDetailState = ref.watch(jobDetailViewModelProvider(jobId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Chi tiết công việc'),
        centerTitle: true,
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
          final company = job.company;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company header
                Container(
                  color: AppColors.background,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child:
                              company?.logoUrl != null
                                  ? Image.network(
                                    company!.logoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Icon(
                                          Icons.business,
                                          color: AppColors.primary,
                                          size: 40,
                                        ),
                                  )
                                  : Icon(
                                    Icons.business,
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                        ),
                      ),
                      const Gap(16),
                      // Job Title
                      Text(
                        job.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Gap(8),
                      // Company Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            company?.name ?? 'Công ty tuyển dụng',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const Gap(4),
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      const Gap(20),
                      // Info Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          if (job.salaryMin != null || job.salaryMax != null)
                            _buildInfoChip(
                              context,
                              Icons.payments_outlined,
                              _getSalaryText(job),
                              AppColors.success,
                            ),
                          if (job.location != null)
                            _buildInfoChip(
                              context,
                              Icons.location_on_outlined,
                              job.location!,
                              AppColors.primary,
                            ),
                          if (job.jobType != null)
                            _buildInfoChip(
                              context,
                              Icons.work_outline,
                              job.jobType!,
                              AppColors.secondary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(12),

                // Job description
                _buildSection(context, 'Mô tả công việc', job.description),
                const Gap(12),

                // Job requirements
                _buildSection(context, 'Yêu cầu công việc', job.requirements),
                const Gap(12),

                // Benefits (New)
                if (job.benefits != null)
                  _buildSection(context, 'Quyền lợi', job.benefits!),

                // Company Info (New)
                if (company?.description != null)
                  _buildSection(context, 'Về công ty', company!.description!),

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
      bottomNavigationBar: jobDetailState.maybeWhen(
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
                    context.go('/jobs/$jobId/apply');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Ứng tuyển ngay',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const Gap(6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gap(12),
          // Parse content for bullets
          ...content.split('\n').map((line) {
            if (line.trim().isEmpty) return const SizedBox.shrink();
            final isBullet =
                line.trim().startsWith('-') || line.trim().startsWith('•');
            final text =
                isBullet ? line.trim().substring(1).trim() : line.trim();

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isBullet) ...[
                    Text(
                      '•',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Gap(8),
                  ],
                  Expanded(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
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
