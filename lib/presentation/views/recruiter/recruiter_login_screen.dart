import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';

/// Recruiter login screen (Web-optimized)
class RecruiterLoginScreen extends HookConsumerWidget {
  const RecruiterLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Left side - Branding
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(64),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.business_center,
                          size: 80,
                          color: AppColors.white,
                        ),
                        const Gap(32),
                        Text(
                          'Job Connect',
                          style: Theme.of(
                            context,
                          ).textTheme.displayMedium?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(16),
                        Text(
                          'Recruiter Portal',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                        const Gap(24),
                        Text(
                          'Quản lý tuyển dụng thông minh với AI',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: AppColors.white.withOpacity(0.8),
                          ),
                        ),
                        const Gap(48),
                        _FeatureItem(
                          icon: Icons.dashboard,
                          text: 'Dashboard tổng quan',
                        ),
                        const Gap(16),
                        _FeatureItem(
                          icon: Icons.view_kanban,
                          text: 'Kanban board quản lý ứng viên',
                        ),
                        const Gap(16),
                        _FeatureItem(
                          icon: Icons.auto_awesome,
                          text: 'AI đánh giá CV tự động',
                        ),
                      ],
                    ),
                  ),
                ),

                // Right side - Login form
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(64),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Đăng nhập',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Gap(8),
                        Text(
                          'Chào mừng trở lại! Vui lòng đăng nhập để tiếp tục.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const Gap(48),

                        // Email field
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'recruiter@example.com',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const Gap(24),

                        // Password field
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                        ),
                        const Gap(16),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                            },
                            child: const Text('Quên mật khẩu?'),
                          ),
                        ),
                        const Gap(24),

                        // Login button
                        authState.maybeWhen(
                          loading:
                              () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          orElse:
                              () => ElevatedButton(
                                onPressed: () async {
                                  await ref
                                      .read(authViewModelProvider.notifier)
                                      .signIn(
                                        emailController.text.trim(),
                                        passwordController.text,
                                      );

                                  // Check auth state and navigate based on role
                                  final currentAuthState = ref.read(
                                    authViewModelProvider,
                                  );
                                  currentAuthState.whenOrNull(
                                    authenticated: (user) {
                                      if (context.mounted) {
                                        if (user.role == 'recruiter') {
                                          context.go('/recruiter/dashboard');
                                        } else {
                                          // Wrong role
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Tài khoản này không phải là nhà tuyển dụng',
                                              ),
                                            ),
                                          );
                                          ref
                                              .read(
                                                authViewModelProvider.notifier,
                                              )
                                              .signOut();
                                        }
                                      }
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Đăng nhập',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                        ),

                        // Error message
                        authState.whenOrNull(
                              error:
                                  (message) => Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      message,
                                      style: TextStyle(
                                        color: AppColors.error,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                            ) ??
                            const SizedBox.shrink(),

                        const Gap(24),

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Chưa có tài khoản? ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/register');
                              },
                              child: const Text('Đăng ký ngay'),
                            ),
                          ],
                        ),

                        const Gap(16),

                        // Candidate login link
                        TextButton.icon(
                          onPressed: () {
                            context.go('/login');
                          },
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: const Text('Đăng nhập với tư cách ứng viên'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.white, size: 24),
        const Gap(12),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}
