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
      backgroundColor: AppColors.white,
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
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
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
    );
  }
}
