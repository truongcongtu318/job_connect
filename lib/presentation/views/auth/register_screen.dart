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
import 'package:job_connect/presentation/widgets/auth/role_card.dart';

/// Register screen with role selection and validation
class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(registerFormViewModelProvider);
    final formNotifier = ref.read(registerFormViewModelProvider.notifier);

    final emailController = useTextEditingController(text: formState.email);
    final passwordController = useTextEditingController(
      text: formState.password,
    );
    final confirmPasswordController = useTextEditingController(
      text: formState.confirmPassword,
    );
    final fullNameController = useTextEditingController(
      text: formState.fullName,
    );
    final phoneController = useTextEditingController(
      text: formState.phone ?? '',
    );
    final companyNameController = useTextEditingController(
      text: formState.companyName ?? '',
    );

    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppStrings.register),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          onPressed:
              formState.isLoading
                  ? null
                  : () {
                    formNotifier.reset();
                    context.go('/login');
                  },
        ),
      ),
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
                  constraints: const BoxConstraints(maxWidth: 500),
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
                                CupertinoIcons.exclamationmark_circle,
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

                      // Role selection
                      Text(
                        AppStrings.selectRole,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (formState.roleError != null) ...[
                        const Gap(8),
                        Text(
                          formState.roleError!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.error),
                        ),
                      ],
                      const Gap(16),

                      Row(
                        children: [
                          Expanded(
                            child: RoleCard(
                              role: 'candidate',
                              title: AppStrings.candidate,
                              description: AppStrings.candidateDesc,
                              icon: CupertinoIcons.person_2,
                              isSelected: formState.selectedRole == 'candidate',
                              onTap:
                                  formState.isLoading
                                      ? () {}
                                      : () => formNotifier.setRole('candidate'),
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: RoleCard(
                              role: 'recruiter',
                              title: AppStrings.recruiter,
                              description: AppStrings.recruiterDesc,
                              icon: CupertinoIcons.briefcase,
                              isSelected: formState.selectedRole == 'recruiter',
                              onTap:
                                  formState.isLoading
                                      ? () {}
                                      : () => formNotifier.setRole('recruiter'),
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),

                      // Full name field
                      AuthTextField(
                        label: AppStrings.fullName,
                        hint: 'Nguyễn Văn A',
                        controller: fullNameController,
                        onChanged: formNotifier.setFullName,
                        errorText: formState.fullNameError,
                        textInputAction: TextInputAction.next,
                        enabled: !formState.isLoading,
                      ),
                      const Gap(16),

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

                      // Phone field (optional)
                      AuthTextField(
                        label: '${AppStrings.phone} ${AppStrings.optional}',
                        hint: '0912345678',
                        controller: phoneController,
                        onChanged: formNotifier.setPhone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        enabled: !formState.isLoading,
                      ),
                      const Gap(16),

                      // Company name for recruiters
                      if (formState.selectedRole == 'recruiter') ...[
                        AuthTextField(
                          label:
                              '${AppStrings.companyName} ${AppStrings.optional}',
                          hint: 'Công ty ABC',
                          controller: companyNameController,
                          onChanged: formNotifier.setCompanyName,
                          textInputAction: TextInputAction.next,
                          enabled: !formState.isLoading,
                        ),
                        const Gap(16),
                      ],

                      // Password field
                      AuthTextField(
                        label: AppStrings.password,
                        hint: '••••••••',
                        controller: passwordController,
                        onChanged: formNotifier.setPassword,
                        errorText: formState.passwordError,
                        obscureText: obscurePassword.value,
                        textInputAction: TextInputAction.next,
                        enabled: !formState.isLoading,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword.value
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            obscurePassword.value = !obscurePassword.value;
                          },
                        ),
                      ),
                      const Gap(16),

                      // Confirm password field
                      AuthTextField(
                        label: AppStrings.confirmPassword,
                        hint: '••••••••',
                        controller: confirmPasswordController,
                        onChanged: formNotifier.setConfirmPassword,
                        errorText: formState.confirmPasswordError,
                        obscureText: obscureConfirmPassword.value,
                        textInputAction: TextInputAction.done,
                        enabled: !formState.isLoading,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword.value
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            obscureConfirmPassword.value =
                                !obscureConfirmPassword.value;
                          },
                        ),
                      ),
                      const Gap(32),

                      // Register button
                      ElevatedButton(
                        onPressed:
                            formState.isLoading
                                ? null
                                : () async {
                                  final success = await formNotifier.submit();
                                  if (!success) {
                                    // Error will be shown in generalError or field errors
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
                                : Text(AppStrings.register),
                      ),
                      const Gap(16),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAccount,
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
                                      context.go('/login');
                                    },
                            child: Text(AppStrings.login),
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
