import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/utils/date_formatter.dart';
import 'package:job_connect/data/models/application_model.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/applicant_list_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';

/// Applicant list screen (Mobile-optimized)
class ApplicantListScreen extends HookConsumerWidget {
  final String jobId;

  const ApplicantListScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicantState = ref.watch(applicantListViewModelProvider(jobId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Danh sách ứng viên'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: applicantState.when(
        initial: () => const LoadingIndicator(),
        loading: () => const LoadingIndicator(),
        loaded: (applications) {
          if (applications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.person_2,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const Gap(16),
                  Text(
                    'Chưa có ứng viên nào',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return _ApplicantList(applications: applications, jobId: jobId);
        },
        error:
            (message) => ErrorDisplay(
              message: message,
              onRetry: () {
                ref.invalidate(applicantListViewModelProvider(jobId));
              },
            ),
      ),
    );
  }
}

class _ApplicantList extends ConsumerStatefulWidget {
  final List<ApplicationModel> applications;
  final String jobId;

  const _ApplicantList({required this.applications, required this.jobId});

  @override
  ConsumerState<_ApplicantList> createState() => _ApplicantListState();
}

class _ApplicantListState extends ConsumerState<_ApplicantList> {
  String _selectedFilter = 'all';

  List<ApplicationModel> get _filteredApplications {
    if (_selectedFilter == 'all') {
      return widget.applications;
    }
    return widget.applications
        .where((app) => app.status.toLowerCase() == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps = _filteredApplications;

    return Column(
      children: [
        // Filter Chips
        Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'Tất cả',
                  count: widget.applications.length,
                  isSelected: _selectedFilter == 'all',
                  onTap: () => setState(() => _selectedFilter = 'all'),
                ),
                const Gap(8),
                _FilterChip(
                  label: 'Chờ xử lý',
                  count:
                      widget.applications
                          .where((a) => a.status.toLowerCase() == 'pending')
                          .length,
                  isSelected: _selectedFilter == 'pending',
                  onTap: () => setState(() => _selectedFilter = 'pending'),
                  color: AppColors.warning,
                ),
                const Gap(8),

                _FilterChip(
                  label: 'Đã chấp nhận',
                  count:
                      widget.applications
                          .where((a) => a.status.toLowerCase() == 'accepted')
                          .length,
                  isSelected: _selectedFilter == 'accepted',
                  onTap: () => setState(() => _selectedFilter = 'accepted'),
                  color: AppColors.success,
                ),
                const Gap(8),
                _FilterChip(
                  label: 'Đã từ chối',
                  count:
                      widget.applications
                          .where((a) => a.status.toLowerCase() == 'rejected')
                          .length,
                  isSelected: _selectedFilter == 'rejected',
                  onTap: () => setState(() => _selectedFilter = 'rejected'),
                  color: AppColors.error,
                ),
              ],
            ),
          ),
        ),

        // Applicants List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredApps.length,
            itemBuilder: (context, index) {
              final app = filteredApps[index];
              return _ApplicantCard(application: app, jobId: widget.jobId);
            },
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return Material(
      color: isSelected ? chipColor.withOpacity(0.1) : AppColors.background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? chipColor : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? chipColor : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              const Gap(6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? chipColor : AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplicantCard extends ConsumerWidget {
  final ApplicationModel application;
  final String jobId;

  const _ApplicantCard({required this.application, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidate = application.candidate;
    final candidateName = candidate?.fullName ?? 'Ứng viên ẩn danh';
    final candidateAvatar = candidate?.avatarUrl;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border.withOpacity(0.6)),
      ),
      child: InkWell(
        onTap: () async {
          await context.push(
            '/recruiter/dashboard/jobs/$jobId/applicants/${application.id}',
          );
          // Refresh list when returning from detail screen
          if (context.mounted) {
            ref.read(applicantListViewModelProvider(jobId).notifier).refresh();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      backgroundImage:
                          candidateAvatar != null
                              ? NetworkImage(candidateAvatar)
                              : null,
                      child:
                          candidateAvatar == null
                              ? Text(
                                candidateName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )
                              : null,
                    ),
                  ),
                  const Gap(12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          candidateName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(4),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.clock,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const Gap(4),
                            Text(
                              DateFormatter.formatRelativeTime(
                                application.appliedAt,
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  _StatusBadge(status: application.status),
                ],
              ),
              if (application.coverLetter != null &&
                  application.coverLetter!.isNotEmpty) ...[
                const Gap(12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    application.coverLetter!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'reviewing':
        return AppColors.info;
      case 'shortlisted':
        return const Color(0xFF8B5CF6);
      case 'accepted':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getText() {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Chờ';
      case 'reviewing':
        return 'Xem';
      case 'shortlisted':
        return 'Lọt vòng';
      case 'accepted':
        return 'Nhận';
      case 'rejected':
        return 'Từ chối';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getText(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _getColor(),
        ),
      ),
    );
  }
}
