import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';

/// Recruiter jobs list screen
class RecruiterJobsScreen extends HookConsumerWidget {
  const RecruiterJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Tin tuyển dụng'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: authState.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        authenticated: (user) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.briefcase,
                  size: 80,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Danh sách tin tuyển dụng',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sẽ được triển khai sớm',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        },
        unauthenticated: () => const Center(child: Text('Vui lòng đăng nhập')),
        error: (error) => Center(child: Text('Lỗi: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to job posting screen
          // context.push('/recruiter/jobs/new');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(CupertinoIcons.add),
        label: const Text('Đăng tin'),
      ),
    );
  }
}
