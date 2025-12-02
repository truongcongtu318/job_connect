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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authViewModelProvider);
    final recruiterId = authState.whenOrNull(authenticated: (user) => user.id);

    if (recruiterId == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Tin tuyển dụng'),
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          foregroundColor: theme.appBarTheme.iconTheme?.color,
        ),
        body: const Center(child: Text('Vui lòng đăng nhập')),
      );
    }

    final jobsState = ref.watch(recruiterJobsViewModelProvider(recruiterId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Tin tuyển dụng'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        foregroundColor: theme.appBarTheme.iconTheme?.color,
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
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.5,
                      ),
                    ),
                    const Gap(16),
                    Text(
                      'Chưa có tin tuyển dụng nào',
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.textTheme.bodyMedium?.color,
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
        backgroundColor: theme.colorScheme.primary,
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
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: () {
          context.push('/recruiter/dashboard/jobs/${job.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge?.color,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(8),
                        if (job.location != null)
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.location_solid,
                                size: 14,
                                color: theme.colorScheme.primary,
                              ),
                              const Gap(4),
                              Expanded(
                                child: Text(
                                  job.location!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const Gap(12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          job.status == 'active'
                              ? AppColors.success.withOpacity(0.1)
                              : theme.textTheme.bodyMedium?.color?.withOpacity(
                                0.1,
                              ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      job.status == 'active' ? 'Đang tuyển' : 'Đã đóng',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            job.status == 'active'
                                ? AppColors.success
                                : theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Divider(color: theme.dividerColor.withOpacity(0.5), height: 1),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (job.salaryMin != null || job.salaryMax != null)
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              CupertinoIcons.money_dollar,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const Gap(8),
                          Expanded(
                            child: Text(
                              _formatSalary(job.salaryMin, job.salaryMax),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.time,
                        size: 14,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      const Gap(4),
                      Text(
                        _formatDate(job.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
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
      if (min == max) {
        return '${_formatNumber(min)} VND';
      }
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
