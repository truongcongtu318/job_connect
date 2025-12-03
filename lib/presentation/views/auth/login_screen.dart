import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/constants/app_strings.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_state.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:job_connect/presentation/widgets/auth/auth_text_field.dart';

/// Login screen with validation and error handling
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(loginFormViewModelProvider);
    final formNotifier = ref.read(loginFormViewModelProvider.notifier);

    final emailController = useTextEditingController(text: formState.email);
    final passwordController = useTextEditingController(
      text: formState.password,
    );
    final obscurePassword = useState(true);

    // Listen to authentication state
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (user) {
          // Navigate based on role
          if (user.role == 'recruiter') {
            context.go('/recruiter/dashboard');
          } else if (user.role == 'candidate') {
            context.go('/jobs');
          } else {
            context.go('/jobs'); // Default
          }
        },
        orElse: () {},
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background Decoration
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF0FDF4), // Mint Cream
                  Color(0xFFE0F2F1), // Teal 50
                ],
              ),
            ),
          ),
          // Decorative Circles
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Brand Logo (Text-based)
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              CupertinoIcons.briefcase_fill,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          const Gap(16),
                          Text(
                            'JOB CONNECT',
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            'Kết nối nhân tài - Kiến tạo tương lai',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const Gap(40),

                      // Welcome Message
                      Text(
                        AppStrings.pleaseSignIn,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Gap(32),

                      // Login Form Card
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow.withValues(alpha: 0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // General error message
                            if (formState.generalError != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.error),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons
                                          .exclamationmark_circle_fill,
                                      color: AppColors.error,
                                      size: 20,
                                    ),
                                    const Gap(8),
                                    Expanded(
                                      child: Text(
                                        formState.generalError!,
                                        style: TextStyle(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(16),
                            ],

                            // Email field
                            AuthTextField(
                              label: AppStrings.email,
                              hint: 'example@email.com',
                              controller: emailController,
                              onChanged: formNotifier.setEmail,
                              errorText: formState.emailError,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              enabled: !formState.isLoading,
                              prefixIcon: Icon(
                                CupertinoIcons.mail,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                            const Gap(16),

                            // Password field
                            AuthTextField(
                              label: AppStrings.password,
                              hint: '••••••••',
                              controller: passwordController,
                              onChanged: formNotifier.setPassword,
                              errorText: formState.passwordError,
                              obscureText: obscurePassword.value,
                              textInputAction: TextInputAction.done,
                              enabled: !formState.isLoading,
                              prefixIcon: Icon(
                                CupertinoIcons.lock,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword.value
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  obscurePassword.value =
                                      !obscurePassword.value;
                                },
                              ),
                            ),
                            const Gap(8),

                            // Forgot Password Link
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  AppStrings.forgotPassword,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(24),

                            // Login button
                            ElevatedButton(
                              onPressed:
                                  formState.isLoading
                                      ? null
                                      : () async {
                                        final success =
                                            await formNotifier.submit();
                                        if (!success) {
                                          // Error will be shown in generalError
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                shadowColor: AppColors.primary.withValues(alpha: 0.4),
                              ),
                              child:
                                  formState.isLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        AppStrings.login,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),

                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.dontHaveAccount,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const Gap(4),
                          TextButton(
                            onPressed:
                                formState.isLoading
                                    ? null
                                    : () {
                                      formNotifier.reset();
                                      context.go('/register');
                                    },
                            child: Text(
                              AppStrings.register,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
