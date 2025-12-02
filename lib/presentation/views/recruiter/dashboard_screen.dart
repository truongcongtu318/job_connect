import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/recruiter_dashboard_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

/// Recruiter dashboard screen (Mobile-optimized)
class RecruiterDashboardScreen extends HookConsumerWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authViewModelProvider);
    final recruiterId = authState.whenOrNull(authenticated: (user) => user.id);
    final userRole = authState.whenOrNull(authenticated: (user) => user.role);

    // Redirect if not recruiter
    if (userRole != null && userRole != 'recruiter') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/jobs');
        }
      });
    }

    if (recruiterId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: const Center(child: Text('Vui lòng đăng nhập')),
      );
    }

    final dashboardState = ref.watch(
      recruiterDashboardViewModelProvider(recruiterId),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        foregroundColor: theme.appBarTheme.iconTheme?.color,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/recruiter/dashboard/jobs/new');
            },
            icon: const Icon(CupertinoIcons.add_circled),
            tooltip: 'Đăng tin',
          ),
        ],
      ),
      body: dashboardState.when(
        initial: () => const LoadingIndicator(),
        loading: () => const LoadingIndicator(),
        loaded: (jobs, totalJobs, activeJobs, totalApplications) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(
                    recruiterDashboardViewModelProvider(recruiterId).notifier,
                  )
                  .refresh();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  Text(
                    'Xin chào 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Quản lý tuyển dụng của bạn',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const Gap(24),

                  // Company Requirement Banner (if no company)
                  if (authState.whenOrNull(
                        authenticated: (user) => user.companyId,
                      ) ==
                      null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.warning.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.exclamationmark_triangle_fill,
                            color: AppColors.warning,
                            size: 24,
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Yêu cầu hồ sơ công ty',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  'Vui lòng tạo hồ sơ công ty để bắt đầu đăng tin tuyển dụng',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(8),
                          ElevatedButton(
                            onPressed: () {
                              context.push(
                                '/recruiter/dashboard/company/profile',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.warning,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Tạo ngay',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                  ],

                  // Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: CupertinoIcons.briefcase,
                          label: 'Tin tuyển dụng',
                          value: totalJobs.toString(),
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _StatCard(
                          icon: CupertinoIcons.checkmark_circle,
                          label: 'Đang tuyển',
                          value: activeJobs.toString(),
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  _StatCard(
                    icon: CupertinoIcons.person_2,
                    label: 'Tổng ứng viên',
                    value: totalApplications.toString(),
                    color: AppColors.info,
                  ),
                  const Gap(24),

                  // Company Profile Card
                  InkWell(
                    onTap: () {
                      context.push('/recruiter/dashboard/company/profile');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.1),
                            theme.colorScheme.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              CupertinoIcons.building_2_fill,
                              color: theme.colorScheme.primary,
                              size: 28,
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hồ sơ công ty',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  'Quản lý thông tin công ty của bạn',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            CupertinoIcons.chevron_right,
                            color: theme.textTheme.bodyMedium?.color,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(32),

                  // Recent Jobs Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tin tuyển dụng gần đây',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (jobs.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            // Navigate to jobs list
                          },
                          child: const Text('Xem tất cả'),
                        ),
                    ],
                  ),
                  const Gap(16),

                  // Jobs List
                  if (jobs.isEmpty)
                    Center(
                      child: Column(
                        children: [
                          const Gap(32),
                          Icon(
                            CupertinoIcons.briefcase,
                            size: 64,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.5),
                          ),
                          const Gap(16),
                          Text(
                            'Chưa có tin tuyển dụng nào',
                            style: TextStyle(
                              fontSize: 16,
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
                  else
                    ...jobs.take(5).map((job) {
                      return _JobCard(
                        job: job,
                        onTap: () {
                          context.push('/recruiter/dashboard/jobs/${job.id}');
                        },
                      );
                    }),
                ],
              ),
            ),
          );
        },
        error:
            (message) => ErrorDisplay(
              message: message,
              onRetry: () {
                ref.invalidate(
                  recruiterDashboardViewModelProvider(recruiterId),
                );
              },
            ),
      ),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
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
              fontSize: 12,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}

// Job Card Widget
class _JobCard extends StatelessWidget {
  final dynamic job;
  final VoidCallback onTap;

  const _JobCard({required this.job, required this.onTap});

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
        onTap: onTap,
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
