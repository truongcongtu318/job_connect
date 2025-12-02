import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';

/// Recruiter profile screen
class RecruiterProfileScreen extends HookConsumerWidget {
  const RecruiterProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: authState.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        authenticated: (user) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage:
                      user.avatarUrl != null
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                  child:
                      user.avatarUrl == null
                          ? Text(
                            user.fullName[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                          : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (user.companyName != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    user.companyName!,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(authViewModelProvider.notifier).signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Đăng xuất'),
                  ),
                ),
              ],
            ),
          );
        },
        unauthenticated: () => const Center(child: Text('Vui lòng đăng nhập')),
        error: (error) => Center(child: Text('Lỗi: $error')),
      ),
    );
  }
}
