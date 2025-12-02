import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/recruiter_dashboard_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

/// Recruiter dashboard screen (Web-optimized)
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
      backgroundColor: const Color(0xFFF9FAFB),
      body: Row(
        children: [
          // Sidebar
          _Sidebar(recruiterId: recruiterId),

          // Main content
          Expanded(
            child: dashboardState.when(
              initial: () => const LoadingIndicator(),
              loading: () => const LoadingIndicator(),
              loaded: (jobs, totalJobs, activeJobs, totalApplications) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(
                          recruiterDashboardViewModelProvider(
                            recruiterId,
                          ).notifier,
                        )
                        .refresh();
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dashboard',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Gap(4),
                                Text(
                                  'Chào mừng trở lại! 👋',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.go('/recruiter/jobs/new');
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Đăng tin mới'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(32),

                        // Statistics Cards
                        _ModernStatisticsSection(
                          totalJobs: totalJobs,
                          activeJobs: activeJobs,
                          totalApplications: totalApplications,
                        ),
                        const Gap(32),

                        // Charts Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _ApplicationsChart(
                                totalApplications: totalApplications,
                              ),
                            ),
                            const Gap(24),
                            Expanded(
                              child: _JobStatusChart(
                                totalJobs: totalJobs,
                                activeJobs: activeJobs,
                              ),
                            ),
                          ],
                        ),
                        const Gap(32),

                        // Recent Jobs
                        _RecentJobsSection(
                          jobs: jobs,
                          recruiterId: recruiterId,
                        ),
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
          ),
        ],
      ),
    );
  }
}

// Sidebar Navigation
class _Sidebar extends StatelessWidget {
  final String recruiterId;

  const _Sidebar({required this.recruiterId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.business_center,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const Gap(12),
                Text(
                  'Job Connect',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _NavItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  isActive: true,
                  onTap: () => context.go('/recruiter/dashboard'),
                ),
                const Gap(8),
                _NavItem(
                  icon: Icons.work,
                  label: 'Tin tuyển dụng',
                  onTap: () {},
                ),
                const Gap(8),
                _NavItem(icon: Icons.people, label: 'Ứng viên', onTap: () {}),
                const Gap(8),
                _NavItem(
                  icon: Icons.analytics,
                  label: 'Thống kê',
                  onTap: () {},
                ),
                const Gap(8),
                _NavItem(icon: Icons.settings, label: 'Cài đặt', onTap: () {}),
              ],
            ),
          ),

          const Divider(height: 1),

          // User Profile
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                  child: const Icon(Icons.person, color: Color(0xFF6366F1)),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recruiter',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'View profile',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          isActive
              ? const Color(0xFF6366F1).withOpacity(0.1)
              : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color:
                    isActive
                        ? const Color(0xFF6366F1)
                        : AppColors.textSecondary,
              ),
              const Gap(12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      isActive
                          ? const Color(0xFF6366F1)
                          : AppColors.textPrimary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modern Statistics Section
class _ModernStatisticsSection extends StatelessWidget {
  final int totalJobs;
  final int activeJobs;
  final int totalApplications;

  const _ModernStatisticsSection({
    required this.totalJobs,
    required this.activeJobs,
    required this.totalApplications,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ModernStatCard(
            title: 'Tổng số tin',
            value: totalJobs.toString(),
            icon: Icons.work_outline,
            color: const Color(0xFF6366F1),
            trend: '+12%',
            trendUp: true,
          ),
        ),
        const Gap(24),
        Expanded(
          child: _ModernStatCard(
            title: 'Đang tuyển',
            value: activeJobs.toString(),
            icon: Icons.trending_up,
            color: const Color(0xFF10B981),
            trend: '+8%',
            trendUp: true,
          ),
        ),
        const Gap(24),
        Expanded(
          child: _ModernStatCard(
            title: 'Ứng viên',
            value: totalApplications.toString(),
            icon: Icons.people_outline,
            color: const Color(0xFF8B5CF6),
            trend: '+23%',
            trendUp: true,
          ),
        ),
      ],
    );
  }
}

class _ModernStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final bool trendUp;

  const _ModernStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      trendUp
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color:
                          trendUp
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                    ),
                    const Gap(4),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            trendUp
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Applications Chart
class _ApplicationsChart extends StatelessWidget {
  final int totalApplications;

  const _ApplicationsChart({required this.totalApplications});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ứng viên theo thời gian',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gap(24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 5),
                      const FlSpot(2, 4),
                      const FlSpot(3, 7),
                      const FlSpot(4, 6),
                      const FlSpot(5, 9),
                    ],
                    isCurved: true,
                    color: const Color(0xFF6366F1),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Job Status Chart
class _JobStatusChart extends StatelessWidget {
  final int totalJobs;
  final int activeJobs;

  const _JobStatusChart({required this.totalJobs, required this.activeJobs});

  @override
  Widget build(BuildContext context) {
    final closedJobs = totalJobs - activeJobs;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trạng thái tin',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gap(24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: activeJobs.toDouble(),
                    title: '$activeJobs',
                    color: const Color(0xFF10B981),
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: closedJobs.toDouble(),
                    title: '$closedJobs',
                    color: const Color(0xFFEF4444),
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Recent Jobs Section
class _RecentJobsSection extends StatelessWidget {
  final List<dynamic> jobs;
  final String recruiterId;

  const _RecentJobsSection({required this.jobs, required this.recruiterId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tin tuyển dụng gần đây',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('Xem tất cả')),
            ],
          ),
          const Gap(16),
          if (jobs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const Gap(16),
                    Text(
                      'Chưa có tin tuyển dụng nào',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: jobs.length > 5 ? 5 : jobs.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final job = jobs[index];
                return _JobListItem(job: job);
              },
            ),
        ],
      ),
    );
  }
}

class _JobListItem extends StatelessWidget {
  final dynamic job;

  const _JobListItem({required this.job});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.work_outline, color: Color(0xFF6366F1)),
      ),
      title: Text(
        job.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'Đăng ${_formatDate(job.createdAt)}',
        style: TextStyle(color: AppColors.textSecondary),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusBadge(status: job.status),
          const Gap(16),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              context.go('/recruiter/jobs/${job.id}/applicants');
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) {
      return '${diff.inDays} ngày trước';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} giờ trước';
    } else {
      return '${diff.inMinutes} phút trước';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF10B981);
      case 'closed':
        return const Color(0xFFEF4444);
      case 'draft':
        return const Color(0xFFF59E0B);
      default:
        return AppColors.textSecondary;
    }
  }

  String _getText() {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Đang tuyển';
      case 'closed':
        return 'Đã đóng';
      case 'draft':
        return 'Nháp';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getText(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getColor(),
        ),
      ),
    );
  }
}
