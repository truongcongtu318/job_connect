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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Icon
                  Icon(Icons.work_outline, size: 80, color: AppColors.primary),
                  const Gap(16),

                  // Title
                  Text(
                    'Job Connect',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    AppStrings.login,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Gap(40),

                  // General error message
                  if (formState.generalError != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const Gap(8),
                          Expanded(
                            child: Text(
                              formState.generalError!,
                              style: TextStyle(color: AppColors.error),
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        obscurePassword.value = !obscurePassword.value;
                      },
                    ),
                  ),
                  const Gap(24),

                  // Login button
                  ElevatedButton(
                    onPressed:
                        formState.isLoading
                            ? null
                            : () async {
                              final success = await formNotifier.submit();
                              if (!success) {
                                // Error will be shown in generalError
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        formState.isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                            : Text(AppStrings.login),
                  ),
                  const Gap(16),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.dontHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
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
                        child: Text(AppStrings.register),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
