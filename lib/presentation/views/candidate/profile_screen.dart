import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/application/application_history_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/profile/profile_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/jobs/saved_jobs_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

/// Profile screen
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.white, // Swapped to white
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
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryLight,
                            Color(0xFFE0F2F1), // Very light teal
                          ],
                        ),
                        borderRadius: BorderRadius.only(
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
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.primary.withOpacity(
                                0.1,
                              ),
                              backgroundImage:
                                  user.avatarUrl != null
                                      ? NetworkImage(user.avatarUrl!)
                                      : null,
                              child:
                                  user.avatarUrl == null
                                      ? Text(
                                        user.fullName[0].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      )
                                      : null,
                            ),
                          ),
                          const Gap(16),
                          Text(
                            user.fullName,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const Gap(16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push('/profile/edit');
                            },
                            icon: const Icon(CupertinoIcons.pencil, size: 16),
                            label: const Text('Chỉnh sửa hồ sơ'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              side: const BorderSide(color: AppColors.primary),
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
                                  color: AppColors.info,
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
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                          const Gap(32),

                          // Resume Section
                          Text(
                            'CV của tôi',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Gap(12),
                          if (user.resumeUrl != null)
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    AppColors
                                        .background, // Swapped to background color
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                ),
                                title: const Text(
                                  'CV của tôi',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: const Text('PDF Document'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        CupertinoIcons.eye,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: () async {
                                        final uri = Uri.parse(user.resumeUrl!);
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        CupertinoIcons.trash,
                                        color: AppColors.error,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text('Xóa CV?'),
                                                content: const Text(
                                                  'Bạn có chắc chắn muốn xóa CV này không?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: const Text('Hủy'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      ref
                                                          .read(
                                                            profileViewModelProvider
                                                                .notifier,
                                                          )
                                                          .deleteResume();
                                                    },
                                                    child: const Text(
                                                      'Xóa',
                                                      style: TextStyle(
                                                        color: AppColors.error,
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
                            )
                          else
                            InkWell(
                              onTap: () {
                                ref
                                    .read(profileViewModelProvider.notifier)
                                    .uploadResume();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors
                                          .background, // Swapped to background color
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.5),
                                    style:
                                        BorderStyle
                                            .solid, // Changed to solid as requested or keep dashed if preferred, using solid for cleaner look with background color
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.cloud_upload,
                                        size: 32,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const Gap(16),
                                    Text(
                                      'Tải lên CV',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Gap(8),
                                    Text(
                                      'Hỗ trợ định dạng PDF, DOC, DOCX',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const Gap(32),

                          // Settings Section
                          Text(
                            'Cài đặt',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Gap(12),
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  AppColors
                                      .background, // Swapped to background color
                              borderRadius: BorderRadius.circular(16),
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
                                  child: const Divider(
                                    height: 1,
                                    color:
                                        Colors
                                            .white, // White divider on colored background
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
                                                child: const Text(
                                                  'Đăng xuất',
                                                  style: TextStyle(
                                                    color: AppColors.error,
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
                  color: Colors.black.withOpacity(0.3),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background, // Swapped to background color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Gap(12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
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
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
      ),
      trailing: Icon(
        CupertinoIcons.chevron_right,
        size: 16,
        color: AppColors.textSecondary.withOpacity(0.5),
      ),
    );
  }
}
