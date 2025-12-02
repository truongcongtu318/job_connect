import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/jobs/job_viewmodel.dart';
import 'package:job_connect/presentation/widgets/candidate/job_card.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

/// Job list screen for candidates
class JobListScreen extends HookConsumerWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final jobListState = ref.watch(jobListViewModelProvider);
    final jobListNotifier = ref.read(jobListViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Việc làm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo vị trí',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            jobListNotifier.searchJobs('');
                          },
                        )
                        : null,
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                jobListNotifier.searchJobs(value);
              },
            ),
          ),

          // Quick action buttons (optional)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _QuickActionButton(
                  icon: Icons.work_outline,
                  label: 'Việc làm',
                  onTap: () {},
                ),
                const Gap(12),
                _QuickActionButton(
                  icon: Icons.business_outlined,
                  label: 'Công ty',
                  onTap: () {},
                ),
                const Gap(12),
                _QuickActionButton(
                  icon: Icons.description_outlined,
                  label: 'Tạo CV',
                  onTap: () {},
                ),
                const Gap(12),
                _QuickActionButton(
                  icon: Icons.article_outlined,
                  label: 'Blog',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const Gap(16),

          // Discover nearby button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement nearby jobs
              },
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Khám phá việc làm gần bạn'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.success,
                side: const BorderSide(color: AppColors.success),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const Gap(16),

          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gợi ý việc làm phù hợp',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: View all
                  },
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
          ),

          // Job list
          Expanded(
            child: jobListState.when(
              initial:
                  () =>
                      const LoadingIndicator(message: 'Đang tải công việc...'),
              loading:
                  () =>
                      const LoadingIndicator(message: 'Đang tải công việc...'),
              loaded: (jobs) {
                if (jobs.isEmpty) {
                  return ErrorDisplay(
                    message: 'Không tìm thấy công việc phù hợp',
                    icon: Icons.work_off_outlined,
                    onRetry: () => jobListNotifier.refresh(),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => jobListNotifier.refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return JobCard(
                        job: job,
                        onTap: () {
                          context.go('/jobs/${job.id}');
                        },
                        onFavorite: () {
                          // TODO: Implement favorite
                        },
                      );
                    },
                  ),
                );
              },
              error:
                  (message) => ErrorDisplay(
                    message: message,
                    onRetry: () => jobListNotifier.refresh(),
                  ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: AppColors.success,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Tạo CV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_history_outlined),
            activeIcon: Icon(Icons.work_history),
            label: 'Đơn ứng tuyển',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              // TODO: Navigate to CV
              break;
            case 2:
              context.go('/applications');
              break;
            case 3:
              // TODO: Navigate to notifications
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary),
            const Gap(4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
