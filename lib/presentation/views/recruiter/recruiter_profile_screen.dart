import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/recruiter_dashboard_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

/// Recruiter profile screen
class RecruiterProfileScreen extends HookConsumerWidget {
  const RecruiterProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: authState.maybeWhen(
        authenticated: (user) {
          // Watch dashboard stats
          final dashboardState = ref.watch(
            recruiterDashboardViewModelProvider(user.id),
          );

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
                              context.push('/recruiter/profile/edit');
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
                                  label: 'Tin tuyển dụng',
                                  value: dashboardState.maybeWhen(
                                    loaded:
                                        (jobs, total, active, apps) =>
                                            total.toString(),
                                    orElse: () => '0',
                                  ),
                                  icon: CupertinoIcons.briefcase_fill,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Gap(16),
                              Expanded(
                                child: _StatCard(
                                  label: 'Ứng viên',
                                  value: dashboardState.maybeWhen(
                                    loaded:
                                        (jobs, total, active, apps) =>
                                            apps.toString(),
                                    orElse: () => '0',
                                  ),
                                  icon: CupertinoIcons.person_2_fill,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          const Gap(32),

                          // Company Info Section
                          Text(
                            'Thông tin công ty',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Gap(12),
                          InkWell(
                            onTap: () {
                              context.push(
                                '/recruiter/dashboard/company/profile',
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.building_2_fill,
                                      color: AppColors.primary,
                                      size: 28,
                                    ),
                                  ),
                                  const Gap(16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.companyName ?? 'Chưa cập nhật',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Gap(4),
                                        Text(
                                          'Quản lý thông tin công ty',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    CupertinoIcons.chevron_right,
                                    color: AppColors.textSecondary.withOpacity(
                                      0.5,
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
                              color: AppColors.background,
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
                                    color: Colors.white,
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
            ],
          );
        },
        unauthenticated: () => const Center(child: Text('Vui lòng đăng nhập')),
        error: (error) => Center(child: Text('Lỗi: $error')),
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
        color: AppColors.background,
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
