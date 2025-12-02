import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/notifications/notification_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(notificationViewModelProvider.notifier).markAllAsRead();
            },
            child: const Text('Đánh dấu đã đọc'),
          ),
        ],
      ),
      body: notificationState.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.bell_slash_fill,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bạn chưa có thông báo nào',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh:
                () =>
                    ref.read(notificationViewModelProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  tileColor:
                      notification.isRead
                          ? Colors.transparent
                          : AppColors.primary.withOpacity(0.05),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getIconColor(notification.type).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIcon(notification.type),
                      color: _getIconColor(notification.type),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight:
                          notification.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(notification.message),
                      const SizedBox(height: 4),
                      Text(
                        timeago.format(notification.createdAt, locale: 'vi'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (!notification.isRead) {
                      ref
                          .read(notificationViewModelProvider.notifier)
                          .markAsRead(notification.id);
                    }
                    // Handle navigation based on type if needed
                  },
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(message: 'Đang tải thông báo...'),
        error:
            (error, stack) => ErrorDisplay(
              message: 'Không thể tải thông báo',
              onRetry: () => ref.refresh(notificationViewModelProvider),
            ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'application_status':
        return CupertinoIcons.doc_text_fill;
      case 'new_job':
        return CupertinoIcons.briefcase_fill;
      case 'system':
      default:
        return CupertinoIcons.bell_fill;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'application_status':
        return Colors.blue;
      case 'new_job':
        return Colors.green;
      case 'system':
      default:
        return AppColors.primary;
    }
  }
}
