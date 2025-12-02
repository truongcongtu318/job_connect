import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/recruiter_jobs_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';

/// Recruiter jobs list screen
class RecruiterJobsScreen extends HookConsumerWidget {
  const RecruiterJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final recruiterId = authState.whenOrNull(authenticated: (user) => user.id);

    if (recruiterId == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('Tin tuyển dụng'),
          backgroundColor: AppColors.white,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        body: const Center(child: Text('Vui lòng đăng nhập')),
      );
    }

    final jobsState = ref.watch(recruiterJobsViewModelProvider(recruiterId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Tin tuyển dụng'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: switch (jobsState) {
        RecruiterJobsInitial() => const LoadingIndicator(),
        RecruiterJobsLoading() => const LoadingIndicator(),
        RecruiterJobsError(:final message) => ErrorDisplay(
          message: message,
          onRetry: () {
            ref.invalidate(recruiterJobsViewModelProvider(recruiterId));
          },
        ),
        RecruiterJobsLoaded(:final jobs) =>
          jobs.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.briefcase,
                      size: 80,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const Gap(16),
                    Text(
                      'Chưa có tin tuyển dụng nào',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Gap(8),
                    TextButton.icon(
                      onPressed: () {
                        context.push('/recruiter/dashboard/jobs/new');
                      },
                      icon: const Icon(CupertinoIcons.add),
                      label: const Text('Đăng tin ngay'),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(
                        recruiterJobsViewModelProvider(recruiterId).notifier,
                      )
                      .refresh();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return _JobCard(job: job);
                  },
                ),
              ),
      },
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/recruiter/dashboard/jobs/new');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(CupertinoIcons.add),
        label: const Text('Đăng tin'),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final dynamic job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () {
          context.push('/recruiter/dashboard/jobs/${job.id}/applicants');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          job.status == 'active'
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      job.status == 'active' ? 'Đang tuyển' : 'Đã đóng',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            job.status == 'active'
                                ? AppColors.success
                                : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              if (job.location != null) ...[
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.location,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const Gap(4),
                    Text(
                      job.location!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
              ],
              if (job.salaryMin != null || job.salaryMax != null) ...[
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.money_dollar_circle,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const Gap(4),
                    Text(
                      _formatSalary(job.salaryMin, job.salaryMax),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
              ],
              Row(
                children: [
                  Icon(
                    CupertinoIcons.time,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const Gap(4),
                  Text(
                    _formatDate(job.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hôm nay';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
