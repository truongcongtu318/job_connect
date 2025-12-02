import 'package:flutter/material.dart';
import 'package:job_connect/core/constants/app_colors.dart';

/// Custom text field widget for authentication forms
class AuthTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;

  const AuthTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled ? AppColors.white : AppColors.background,
          ),
        ),
      ],
    );
  }
}
