import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/utils/date_formatter.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/recruiter_job_detail_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

class RecruiterJobDetailScreen extends HookConsumerWidget {
  final String jobId;

  const RecruiterJobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final state = ref.watch(recruiterJobDetailViewModelProvider(jobId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Chi tiết tin tuyển dụng'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        foregroundColor: theme.appBarTheme.iconTheme?.color,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to edit job
            },
            icon: const Icon(CupertinoIcons.pencil),
            tooltip: 'Chỉnh sửa',
          ),
        ],
      ),
      body: state.when(
        initial: () => const LoadingIndicator(),
        loading: () => const LoadingIndicator(),
        error:
            (message) => ErrorDisplay(
              message: message,
              onRetry: () {
                ref.invalidate(recruiterJobDetailViewModelProvider(jobId));
              },
            ),
        loaded: (job, applicantCount, newApplicantCount) {
          final isActive = job.status == 'active';

          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(recruiterJobDetailViewModelProvider(jobId).notifier)
                  .refresh();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                isActive
                                    ? AppColors.success.withOpacity(0.1)
                                    : textTheme.bodyMedium?.color?.withOpacity(
                                      0.1,
                                    ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isActive
                                ? CupertinoIcons.checkmark_circle_fill
                                : CupertinoIcons.lock_fill,
                            color:
                                isActive
                                    ? AppColors.success
                                    : textTheme.bodyMedium?.color,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isActive ? 'Đang tuyển dụng' : 'Đã đóng',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isActive
                                          ? AppColors.success
                                          : textTheme.bodyMedium?.color,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                isActive
                                    ? 'Ứng viên có thể nộp hồ sơ'
                                    : 'Tạm ngưng nhận hồ sơ mới',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: isActive,
                          onChanged: (value) {
                            ref
                                .read(
                                  recruiterJobDetailViewModelProvider(
                                    jobId,
                                  ).notifier,
                                )
                                .toggleJobStatus(value);
                          },
                          activeColor: AppColors.success,
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),

                  // Stats Overview
                  Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          label: 'Tổng ứng viên',
                          value: applicantCount.toString(),
                          icon: CupertinoIcons.person_2_fill,
                          color: colorScheme.primary,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _StatBox(
                          label: 'Mới ứng tuyển',
                          value: newApplicantCount.toString(),
                          icon: CupertinoIcons.sparkles,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),

                  // View Applicants Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push(
                          '/recruiter/dashboard/jobs/$jobId/applicants',
                        );
                      },
                      icon: const Icon(CupertinoIcons.list_bullet),
                      label: const Text('Xem danh sách ứng viên'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const Gap(24),

                  // Job Details
                  Text(
                    'Thông tin chi tiết',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textTheme.bodyLarge?.color,
                          ),
                        ),
                        const Gap(8),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.location,
                              size: 16,
                              color: textTheme.bodyMedium?.color,
                            ),
                            const Gap(4),
                            Text(
                              job.location ?? 'Chưa cập nhật',
                              style: TextStyle(
                                color: textTheme.bodyMedium?.color,
                              ),
                            ),
                            const Gap(16),
                            Icon(
                              CupertinoIcons.money_dollar_circle,
                              size: 16,
                              color: textTheme.bodyMedium?.color,
                            ),
                            const Gap(4),
                            Text(
                              _formatSalary(job.salaryMin, job.salaryMax),
                              style: TextStyle(
                                color: textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        const Divider(),
                        const Gap(20),
                        _SectionTitle(title: 'Mô tả công việc'),
                        const Gap(8),
                        Text(
                          job.description,
                          style: TextStyle(
                            height: 1.5,
                            color: textTheme.bodyLarge?.color,
                          ),
                        ),
                        if (job.requirements.isNotEmpty) ...[
                          const Gap(20),
                          _SectionTitle(title: 'Yêu cầu'),
                          const Gap(8),
                          Text(
                            job.requirements,
                            style: TextStyle(
                              height: 1.5,
                              color: textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                        const Gap(20),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.time,
                              size: 14,
                              color: textTheme.bodyMedium?.color,
                            ),
                            const Gap(6),
                            Text(
                              'Đăng ngày: ${DateFormatter.formatDate(job.createdAt)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatSalary(double? min, double? max) {
    if (min == null && max == null) return 'Thỏa thuận';
    if (min != null && max != null) {
      return '${_formatNumber(min)} - ${_formatNumber(max)} VND';
    }
    if (min != null) return 'Từ ${_formatNumber(min)} VND';
    return 'Đến ${_formatNumber(max!)} VND';
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(0)}M';
    }
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(0);
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Gap(12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const Gap(4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}
