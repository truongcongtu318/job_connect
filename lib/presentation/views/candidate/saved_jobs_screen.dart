import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/jobs/saved_jobs_viewmodel.dart';
import 'package:job_connect/presentation/widgets/candidate/job_card.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

class SavedJobsScreen extends ConsumerWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedJobsState = ref.watch(savedJobsViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Việc làm đã lưu')),
      body: savedJobsState.when(
        data: (jobs) {
          if (jobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.bookmark_fill,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có việc làm nào được lưu',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go('/jobs'),
                    child: const Text('Khám phá việc làm ngay'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return JobCard(
                job: job,
                isFavorite: true,
                onTap: () => context.go('/jobs/${job.id}'),
                onFavorite: () {
                  ref
                      .read(savedJobsViewModelProvider.notifier)
                      .toggleSaveJob(job.id);
                },
              );
            },
          );
        },
        loading: () => const LoadingIndicator(message: 'Đang tải...'),
        error:
            (error, stack) => ErrorDisplay(
              message: 'Không thể tải danh sách đã lưu',
              onRetry: () => ref.refresh(savedJobsViewModelProvider),
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
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
              context.go('/jobs');
              break;
            case 1:
              // Already on saved jobs
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
