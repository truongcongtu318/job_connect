import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/jobs/job_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/jobs/saved_jobs_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/jobs/category_viewmodel.dart';
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
    final authState = ref.watch(authViewModelProvider);
    final userName = authState.whenOrNull(
      authenticated: (user) => user.fullName,
    );

    // Local state for selected category
    final selectedCategory = useState<String>('All');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.briefcase_fill,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chào, ${userName ?? "Bạn"} 👋',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tìm việc ngay hôm nay!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.bell),
            onPressed: () {
              context.push('/notifications');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo vị trí',
                  prefixIcon: const Icon(CupertinoIcons.search),
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(
                              CupertinoIcons.clear_circled_solid,
                            ),
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                onSubmitted: (value) {
                  jobListNotifier.searchJobs(value);
                },
              ),
            ),
          ),

          // Category Chips
          Consumer(
            builder: (context, ref, child) {
              final categoriesState = ref.watch(categoryViewModelProvider);

              return categoriesState.when(
                data:
                    (categories) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          for (final category in categories)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(category),
                                selected: selectedCategory.value == category,
                                onSelected: (selected) {
                                  if (selected) {
                                    selectedCategory.value = category;
                                    if (category == 'All') {
                                      jobListNotifier.searchJobs('');
                                    } else {
                                      jobListNotifier.searchJobs(category);
                                    }
                                  }
                                },
                                selectedColor: AppColors.primary,
                                backgroundColor: AppColors.white,
                                side: BorderSide(
                                  color:
                                      selectedCategory.value == category
                                          ? AppColors.primary
                                          : AppColors.border,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelStyle: TextStyle(
                                  color:
                                      selectedCategory.value == category
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                loading:
                    () => const SizedBox(
                      height: 40,
                      child: Center(child: CupertinoActivityIndicator()),
                    ),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
          const Gap(16),

          // Discover nearby button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement nearby jobs
                },
                icon: const Icon(CupertinoIcons.compass, color: Colors.white),
                label: const Text('Khám phá việc làm gần bạn'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                ),
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
                    icon: CupertinoIcons.briefcase,
                    onRetry: () => jobListNotifier.refresh(),
                  );
                }

                final savedJobsState = ref.watch(savedJobsViewModelProvider);
                final savedJobIds = savedJobsState.maybeWhen(
                  data: (savedJobs) => savedJobs.map((j) => j.id).toSet(),
                  orElse: () => <String>{},
                );

                return RefreshIndicator(
                  onRefresh: () async {
                    await jobListNotifier.refresh();
                    await ref
                        .read(savedJobsViewModelProvider.notifier)
                        .refresh();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      final isSaved = savedJobIds.contains(job.id);

                      return JobCard(
                        job: job,
                        isFavorite: isSaved,
                        onTap: () {
                          context.go('/jobs/${job.id}');
                        },
                        onFavorite: () {
                          ref
                              .read(savedJobsViewModelProvider.notifier)
                              .toggleSaveJob(job.id);
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
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bookmark),
            activeIcon: Icon(CupertinoIcons.bookmark_fill),
            label: 'Đã lưu',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_text),
            activeIcon: Icon(CupertinoIcons.doc_text_fill),
            label: 'Đơn ứng tuyển',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Tài khoản',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              context.go('/saved-jobs');
              break;
            case 2:
              context.go('/applications');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}
