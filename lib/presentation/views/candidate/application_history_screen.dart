import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/utils/date_formatter.dart';
import 'package:job_connect/presentation/viewmodels/application/application_history_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

/// Application history screen
class ApplicationHistoryScreen extends HookConsumerWidget {
  const ApplicationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    // Get candidate ID from profile (not auth user ID)
    final candidateId = authState.whenOrNull(authenticated: (user) => user.id);

    if (candidateId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lịch sử ứng tuyển')),
        body: const Center(child: Text('Vui lòng đăng nhập')),
      );
    }

    final historyState = ref.watch(
      applicationHistoryViewModelProvider(candidateId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Lịch sử ứng tuyển')),
      body: historyState.when(
        initial: () => const LoadingIndicator(),
        loading: () => const LoadingIndicator(),
        loaded: (applications) {
          if (applications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work_outline,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const Gap(16),
                  Text(
                    'Chưa có đơn ứng tuyển nào',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Hãy tìm và ứng tuyển công việc phù hợp',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(
                    applicationHistoryViewModelProvider(candidateId).notifier,
                  )
                  .refresh();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: applications.length,
              separatorBuilder: (context, index) => const Gap(12),
              itemBuilder: (context, index) {
                final application = applications[index];
                return _ApplicationCard(application: application);
              },
            ),
          );
        },
        error:
            (message) => ErrorDisplay(
              message: message,
              onRetry: () {
                ref.invalidate(
                  applicationHistoryViewModelProvider(candidateId),
                );
              },
            ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final dynamic application;

  const _ApplicationCard({required this.application});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'reviewing':
        return AppColors.info;
      case 'shortlisted':
        return AppColors.success;
      case 'accepted':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Chờ xử lý';
      case 'reviewing':
        return 'Đang xem xét';
      case 'shortlisted':
        return 'Đã lọt vòng';
      case 'accepted':
        return 'Đã chấp nhận';
      case 'rejected':
        return 'Đã từ chối';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(application.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getStatusText(application.status),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getStatusColor(application.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Gap(12),

            // Job title (placeholder - need to fetch job details)
            Text(
              'Job ID: ${application.jobId}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(8),

            // Applied date
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const Gap(4),
                Text(
                  'Ứng tuyển: ${DateFormatter.formatRelativeTime(application.appliedAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            // Cover letter preview (if exists)
            if (application.coverLetter != null &&
                application.coverLetter!.isNotEmpty) ...[
              const Gap(8),
              Text(
                application.coverLetter!.length > 100
                    ? '${application.coverLetter!.substring(0, 100)}...'
                    : application.coverLetter!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
