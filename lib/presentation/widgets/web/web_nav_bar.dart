import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_connect/core/constants/app_colors.dart';

class WebNavBar extends StatelessWidget implements PreferredSizeWidget {
  const WebNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).matchedLocation;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          InkWell(
            onTap: () => context.go('/jobs'),
            child: Row(
              children: [
                Icon(Icons.work_rounded, color: AppColors.primary, size: 32),
                const Gap(8),
                Text(
                  'JobConnect',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Navigation Links
          Row(
            children: [
              _NavBarItem(
                title: 'Việc làm',
                isActive: currentPath.startsWith('/jobs'),
                onTap: () => context.go('/jobs'),
              ),
              const Gap(24),
              _NavBarItem(
                title: 'Công ty',
                isActive: currentPath == '/companies',
                onTap: () {}, // TODO
              ),
              const Gap(24),
              _NavBarItem(
                title: 'Hồ sơ & CV',
                isActive: currentPath == '/profile',
                onTap: () => context.go('/profile'),
              ),
              const Gap(24),
              _NavBarItem(
                title: 'Ứng tuyển',
                isActive: currentPath == '/applications',
                onTap: () => context.go('/applications'),
              ),
            ],
          ),

          const Spacer(),

          // Profile / Actions
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.textSecondary,
              ),
              const Gap(16),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Đăng tin tuyển dụng',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          if (isActive) ...[
            const Gap(4),
            Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
