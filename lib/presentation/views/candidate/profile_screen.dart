import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:job_connect/presentation/viewmodels/application/application_history_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/jobs/saved_jobs_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/profile/profile_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

/// Profile screen
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authViewModelProvider);
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: authState.maybeWhen(
        authenticated: (user) {
          // Watch stats providers
          final applicationsState = ref.watch(
            applicationHistoryViewModelProvider(user.id),
          );
          final savedJobsAsync = ref.watch(savedJobsViewModelProvider);

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primaryContainer,
                            theme.colorScheme.secondaryContainer,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              backgroundImage:
                                  user.avatarUrl != null
                                      ? NetworkImage(user.avatarUrl!)
                                      : null,
                              child:
                                  user.avatarUrl == null
                                      ? Text(
                                        user.fullName[0].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      )
                                      : null,
                            ),
                          ),
                          const Gap(16),
                          Text(
                            user.fullName,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            user.email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          const Gap(16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push('/profile/edit');
                            },
                            icon: const Icon(CupertinoIcons.pencil, size: 16),
                            label: const Text('Chỉnh sửa hồ sơ'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.cardColor,
                              foregroundColor: theme.colorScheme.primary,
                              elevation: 0,
                              side: BorderSide(
                                color: theme.colorScheme.primary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stats Row
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  label: 'Đã ứng tuyển',
                                  value: applicationsState.maybeWhen(
                                    loaded: (apps) => apps.length.toString(),
                                    orElse: () => '0',
                                  ),
                                  icon: CupertinoIcons.doc_text_fill,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const Gap(16),
                              Expanded(
                                child: _StatCard(
                                  label: 'Đã lưu',
                                  value: savedJobsAsync.maybeWhen(
                                    data: (jobs) => jobs.length.toString(),
                                    orElse: () => '0',
                                  ),
                                  icon: CupertinoIcons.bookmark_fill,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          const Gap(32),

                          // Settings Section
                          Text(
                            'Cài đặt',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(12),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Column(
                              children: [
                                _SettingsTile(
                                  icon: CupertinoIcons.lock,
                                  title: 'Đổi mật khẩu',
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Tính năng đang phát triển',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Divider(
                                    height: 1,
                                    color: theme.dividerColor,
                                  ),
                                ),
                                _SettingsTile(
                                  icon: CupertinoIcons.arrow_right_square,
                                  title: 'Đăng xuất',
                                  isDestructive: true,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text('Đăng xuất?'),
                                            content: const Text(
                                              'Bạn có chắc chắn muốn đăng xuất không?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: const Text('Hủy'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  ref
                                                      .read(
                                                        authViewModelProvider
                                                            .notifier,
                                                      )
                                                      .signOut();
                                                },
                                                child: Text(
                                                  'Đăng xuất',
                                                  style: TextStyle(
                                                    color:
                                                        theme.colorScheme.error,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Gap(100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (profileState.isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(child: LoadingIndicator()),
                ),
            ],
          );
        },
        orElse: () => const Center(child: LoadingIndicator()),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Gap(12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const Gap(4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color:
              isDestructive ? theme.colorScheme.error : theme.iconTheme.color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color:
              isDestructive
                  ? theme.colorScheme.error
                  : theme.textTheme.bodyLarge?.color,
        ),
      ),
      trailing: Icon(
        CupertinoIcons.chevron_right,
        size: 16,
        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
      ),
    );
  }
}
