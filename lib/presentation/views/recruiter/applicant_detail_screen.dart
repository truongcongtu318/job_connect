import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/utils/date_formatter.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/applicant_detail_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/ai_rating_viewmodel.dart';

/// Applicant detail screen (Mobile-optimized)
class ApplicantDetailScreen extends HookConsumerWidget {
  final String applicationId;

  const ApplicantDetailScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(
      applicantDetailViewModelProvider(applicationId),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Chi tiết ứng viên'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: detailState.when(
        initial: () => const LoadingIndicator(),
        loading: () => const LoadingIndicator(),
        loaded: (application, candidate, job) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Candidate Info Card
                _CandidateInfoCard(
                  candidate: candidate,
                  application: application,
                ),
                const Gap(20),

                // Status Actions
                _StatusActionsCard(
                  application: application,
                  applicationId: applicationId,
                ),
                const Gap(20),

                // AI Insights
                _AIInsightsCard(
                  applicationId: applicationId,
                  resumeUrl: application.resumeUrl,
                  job: job,
                ),
                const Gap(20),

                // Application Details
                _ApplicationDetailsCard(application: application, job: job),
                const Gap(20),

                // Resume Download
                if (application.resumeUrl != null)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(application.resumeUrl!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      icon: const Icon(CupertinoIcons.cloud_download),
                      label: const Text('Tải xuống CV'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        error:
            (message) => ErrorDisplay(
              message: message,
              onRetry: () {
                ref.invalidate(applicantDetailViewModelProvider(applicationId));
              },
            ),
      ),
    );
  }
}

// Candidate Info Card
class _CandidateInfoCard extends StatelessWidget {
  final dynamic candidate;
  final dynamic application;

  const _CandidateInfoCard({
    required this.candidate,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              candidate.fullName?.substring(0, 1).toUpperCase() ?? 'U',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const Gap(16),

          // Name
          Text(
            candidate.fullName ?? 'Unknown',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Gap(8),

          // Status Badge
          _StatusBadge(status: application.status),
          const Gap(20),

          // Contact Info
          _InfoRow(
            icon: CupertinoIcons.mail,
            label: 'Email',
            value: candidate.email ?? 'N/A',
          ),
          const Gap(12),
          _InfoRow(
            icon: CupertinoIcons.phone,
            label: 'Điện thoại',
            value: candidate.phone ?? 'N/A',
          ),
          const Gap(12),
          _InfoRow(
            icon: CupertinoIcons.calendar,
            label: 'Ngày ứng tuyển',
            value: DateFormatter.formatRelativeTime(application.appliedAt),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const Gap(2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Status Actions Card
class _StatusActionsCard extends ConsumerWidget {
  final dynamic application;
  final String applicationId;

  const _StatusActionsCard({
    required this.application,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Hành động',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Gap(16),

          // Accept Button
          ElevatedButton.icon(
            onPressed:
                application.status.toLowerCase() == 'accepted'
                    ? null
                    : () async {
                      final success =
                          await ref
                              .read(
                                applicantDetailViewModelProvider(
                                  applicationId,
                                ).notifier,
                              )
                              .acceptApplication();

                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã chấp nhận ứng viên'),
                          ),
                        );
                      }
                    },
            icon: const Icon(CupertinoIcons.checkmark_circle),
            label: const Text('Chấp nhận'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const Gap(12),

          // Reject Button
          OutlinedButton.icon(
            onPressed:
                application.status.toLowerCase() == 'rejected'
                    ? null
                    : () async {
                      final success =
                          await ref
                              .read(
                                applicantDetailViewModelProvider(
                                  applicationId,
                                ).notifier,
                              )
                              .rejectApplication();

                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã từ chối ứng viên')),
                        );
                      }
                    },
            icon: const Icon(CupertinoIcons.xmark_circle),
            label: const Text('Từ chối'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const Gap(16),

          // Status Dropdown
          DropdownButtonFormField<String>(
            value: application.status.toLowerCase(),
            decoration: InputDecoration(
              labelText: 'Thay đổi trạng thái',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.white,
            ),
            items: const [
              DropdownMenuItem(value: 'pending', child: Text('Chờ xử lý')),
              DropdownMenuItem(value: 'reviewing', child: Text('Đang xem xét')),
              DropdownMenuItem(
                value: 'shortlisted',
                child: Text('Đã lọt vòng'),
              ),
              DropdownMenuItem(value: 'accepted', child: Text('Đã chấp nhận')),
              DropdownMenuItem(value: 'rejected', child: Text('Đã từ chối')),
            ],
            onChanged: (value) async {
              if (value != null) {
                await ref
                    .read(
                      applicantDetailViewModelProvider(applicationId).notifier,
                    )
                    .updateStatus(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

// AI Insights Card
class _AIInsightsCard extends ConsumerWidget {
  final String applicationId;
  final String? resumeUrl;
  final dynamic job;

  const _AIInsightsCard({
    required this.applicationId,
    required this.resumeUrl,
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(aiRatingViewModelProvider(applicationId));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.sparkles,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              const Gap(12),
              const Text(
                'Đánh giá AI',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Gap(16),

          aiState.when(
            initial: () => const SizedBox.shrink(),
            loading:
                () => const Column(
                  children: [
                    CircularProgressIndicator(),
                    Gap(12),
                    Text('Đang phân tích hồ sơ...'),
                  ],
                ),
            error:
                (message) => Column(
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      color: AppColors.error,
                      size: 32,
                    ),
                    const Gap(8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
            notAnalyzed:
                () => Column(
                  children: [
                    Text(
                      'Chưa có đánh giá AI cho hồ sơ này.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const Gap(16),
                    ElevatedButton.icon(
                      onPressed:
                          resumeUrl == null
                              ? null
                              : () {
                                ref
                                    .read(
                                      aiRatingViewModelProvider(
                                        applicationId,
                                      ).notifier,
                                    )
                                    .analyzeApplication(
                                      resumeUrl: resumeUrl!,
                                      jobTitle: job.title,
                                      jobDescription: job.description,
                                      jobRequirements: job.requirements ?? '',
                                    );
                              },
                      icon: const Icon(CupertinoIcons.sparkles),
                      label: const Text('Phân tích ngay'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
            loaded:
                (rating) => Column(
                  children: [
                    // AI Score
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Điểm phù hợp',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const Gap(8),
                          Text(
                            rating.overallScore.toStringAsFixed(0),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'trên 100',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (rating.summary != null) ...[
                      const Gap(16),
                      Text(
                        rating.summary!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ],
                ),
          ),
        ],
      ),
    );
  }
}

// Application Details Card
class _ApplicationDetailsCard extends StatelessWidget {
  final dynamic application;
  final dynamic job;

  const _ApplicationDetailsCard({required this.application, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Thông tin ứng tuyển',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Gap(16),

          _DetailRow(label: 'Vị trí ứng tuyển', value: job.title),
          const Gap(12),
          _DetailRow(
            label: 'Ngày ứng tuyển',
            value: DateFormatter.formatRelativeTime(application.appliedAt),
          ),
          const Gap(12),
          _DetailRow(
            label: 'Trạng thái',
            value: _getStatusText(application.status),
          ),

          if (application.coverLetter != null &&
              application.coverLetter!.isNotEmpty) ...[
            const Gap(20),
            const Text(
              'Thư xin việc',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                application.coverLetter!,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Chờ xử lý';
      case 'reviewing':
        return 'Đang xem xét';
      case 'shortlisted':
        return 'Đã lọt vòng';
      case 'accepted':
        return 'Đã chấp nhận';
      case 'rejected':
        return 'Đã từ chối';
      default:
        return status;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
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
        return 'Chờ xử lý';
      case 'reviewing':
        return 'Đang xem xét';
      case 'shortlisted':
        return 'Đã lọt vòng';
      case 'accepted':
        return 'Đã chấp nhận';
      case 'rejected':
        return 'Đã từ chối';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _getText(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getColor(),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
