import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/utils/extensions.dart';
import 'package:job_connect/presentation/viewmodels/jobs/job_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

/// Job detail screen (Modernized)
class JobDetailScreen extends HookConsumerWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobDetailState = ref.watch(jobDetailViewModelProvider(jobId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Chi tiết công việc'),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.heart),
            onPressed: () {
              // TODO: Add to favorites
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.share),
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
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      // Header Section
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child:
                                    company?.logoUrl != null
                                        ? Image.network(
                                          company!.logoUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) =>
                                                  _buildPlaceholderLogo(),
                                        )
                                        : _buildPlaceholderLogo(),
                              ),
                            ),
                            const Gap(24),
                            Text(
                              job.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                            const Gap(12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  company?.name ?? 'Công ty tuyển dụng',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Gap(6),
                                const Icon(
                                  CupertinoIcons.checkmark_seal_fill,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(32),

                      // Info Chips Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              icon: CupertinoIcons.money_dollar_circle_fill,
                              label: 'Mức lương',
                              value: _getSalaryText(job),
                              color: AppColors.success,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: _buildInfoCard(
                              icon: CupertinoIcons.briefcase_fill,
                              label: 'Hình thức',
                              value: job.jobType ?? 'Toàn thời gian',
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      _buildInfoCard(
                        icon: CupertinoIcons.location_solid,
                        label: 'Địa điểm',
                        value: job.location ?? 'Chưa cập nhật',
                        color: AppColors.primary,
                        isFullWidth: true,
                      ),
                      const Gap(32),

                      // Content Sections
                      _buildSectionTitle('Mô tả công việc'),
                      const Gap(12),
                      _buildFormattedContent(job.description),
                      const Gap(24),

                      _buildSectionTitle('Yêu cầu ứng viên'),
                      const Gap(12),
                      _buildFormattedContent(job.requirements),
                      const Gap(24),

                      if (job.benefits != null && job.benefits!.isNotEmpty) ...[
                        _buildSectionTitle('Quyền lợi'),
                        const Gap(12),
                        _buildFormattedContent(job.benefits!),
                        const Gap(24),
                      ],

                      if (company?.description != null) ...[
                        _buildSectionTitle('Về công ty'),
                        const Gap(12),
                        Text(
                          company!.description!,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Gap(24),
                      ],

                      const Gap(20),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  MediaQuery.of(context).padding.bottom + 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/jobs/$jobId/apply');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ứng tuyển ngay',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(8),
                      Icon(CupertinoIcons.arrow_right),
                    ],
                  ),
                ),
              ),
            ],
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
    );
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      color: AppColors.background,
      child: const Center(
        child: Icon(
          CupertinoIcons.building_2_fill,
          color: AppColors.textSecondary,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment:
            isFullWidth ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFormattedContent(String content) {
    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          lines.map((line) {
            final trimmed = line.trim();
            if (trimmed.isEmpty) return const SizedBox.shrink();

            final isBullet = trimmed.startsWith('-') || trimmed.startsWith('•');
            final text = isBullet ? trimmed.substring(1).trim() : trimmed;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isBullet) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.circle,
                        size: 6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Gap(12),
                  ],
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
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
