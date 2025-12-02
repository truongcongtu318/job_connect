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
  Widget build(BuildContext context, WidgetRef ref) {
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Quản lý tuyển dụng của bạn',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Gap(24),

                  // Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: CupertinoIcons.briefcase,
                          label: 'Tin tuyển dụng',
                          value: totalJobs.toString(),
                          color: AppColors.primary,
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
                          color: AppColors.textPrimary,
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
                            color: AppColors.textSecondary.withOpacity(0.5),
                          ),
                          const Gap(16),
                          Text(
                            'Chưa có tin tuyển dụng nào',
                            style: TextStyle(
                              fontSize: 16,
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
                  else
                    ...jobs.take(5).map((job) {
                      return _JobCard(
                        job: job,
                        onTap: () {
                          context.push(
                            '/recruiter/dashboard/jobs/${job.id}/applicants',
                          );
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
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
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
              if (job.location != null) ...[
                const Gap(8),
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
              ],
              const Gap(8),
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
