import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/utils/extensions.dart';
import 'package:job_connect/data/models/job_model.dart';

/// Job card widget for displaying job in list
class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company logo placeholder
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      CupertinoIcons.building_2_fill,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const Gap(12),
                  // Job info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(4),
                        Text(
                          'Công ty tuyển dụng', // TODO: Add company name to job model
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Favorite button
                  IconButton(
                    onPressed: onFavorite,
                    icon: Icon(
                      isFavorite
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: isFavorite ? Colors.red : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Salary tag
              if (job.salaryMin != null || job.salaryMax != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getSalaryText(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Thỏa thuận',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Gap(8),
              // Location
              if (job.location != null)
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.location_solid,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        job.location!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSalaryText() {
    if (job.salaryMin != null && job.salaryMax != null) {
      return '${job.salaryMin!.toVnd()} - ${job.salaryMax!.toVnd()}';
    } else if (job.salaryMin != null) {
      return 'Từ ${job.salaryMin!.toVnd()}';
    } else if (job.salaryMax != null) {
      return 'Lên đến ${job.salaryMax!.toVnd()}';
    }
    return 'Thỏa thuận';
  }
}
