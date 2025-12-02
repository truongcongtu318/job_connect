import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/utils/date_formatter.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/applicant_detail_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/ai_rating_viewmodel.dart';

/// Applicant detail screen
class ApplicantDetailScreen extends HookConsumerWidget {
  final String applicationId;

  const ApplicantDetailScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(
      applicantDetailViewModelProvider(applicationId),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Chi tiết ứng viên'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(
                    applicantDetailViewModelProvider(applicationId).notifier,
                  )
                  .refresh();
            },
          ),
          const Gap(16),
        ],
      ),
      body: detailState.when(
        initial: () => const LoadingIndicator(),
        loading: () => const LoadingIndicator(),
        loaded: (application, candidate, job) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - Candidate Info & Actions
                SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      _CandidateInfoCard(
                        candidate: candidate,
                        application: application,
                        applicationId: applicationId,
                      ),
                      const Gap(24),
                      _QuickActionsCard(
                        application: application,
                        applicationId: applicationId,
                      ),
                      const Gap(24),
                      _AIInsightsCard(
                        applicationId: applicationId,
                        resumeUrl: application.resumeUrl,
                        job: job,
                      ),
                    ],
                  ),
                ),
                const Gap(24),

                // Right Column - Resume & Details
                Expanded(
                  child: Column(
                    children: [
                      _ResumeViewerCard(resumeUrl: application.resumeUrl),
                      const Gap(24),
                      _ApplicationDetailsCard(
                        application: application,
                        job: job,
                      ),
                    ],
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
  final String applicationId;

  const _CandidateInfoCard({
    required this.candidate,
    required this.application,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
            child: Text(
              candidate.fullName?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
          const Gap(16),

          // Name
          Text(
            candidate.fullName ?? 'Unknown',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Gap(8),

          // Status Badge
          _StatusBadge(status: application.status),
          const Gap(24),

          // Contact Info
          _InfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: candidate.email ?? 'N/A',
          ),
          const Gap(12),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: candidate.phone ?? 'N/A',
          ),
          const Gap(12),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Applied',
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
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Quick Actions Card
class _QuickActionsCard extends ConsumerWidget {
  final dynamic application;
  final String applicationId;

  const _QuickActionsCard({
    required this.application,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Accept'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
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
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Reject'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              side: const BorderSide(color: Color(0xFFEF4444)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const Gap(12),

          // Change Status Dropdown
          DropdownButtonFormField<String>(
            value: application.status.toLowerCase(),
            decoration: const InputDecoration(
              labelText: 'Change Status',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(value: 'reviewing', child: Text('Reviewing')),
              DropdownMenuItem(
                value: 'shortlisted',
                child: Text('Shortlisted'),
              ),
              DropdownMenuItem(value: 'accepted', child: Text('Accepted')),
              DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
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
  final dynamic job; // JobModel

  const _AIInsightsCard({
    required this.applicationId,
    required this.resumeUrl,
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(aiRatingViewModelProvider(applicationId));

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
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
                child: const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6)),
              ),
              const Gap(12),
              Text(
                'AI Insights',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                    Gap(16),
                    Text('Đang phân tích hồ sơ...'),
                  ],
                ),
            error:
                (message) => Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 32,
                    ),
                    const Gap(8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const Gap(16),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(
                              aiRatingViewModelProvider(applicationId).notifier,
                            )
                            .loadRating();
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
            notAnalyzed:
                () => Column(
                  children: [
                    const Text(
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
                      icon: const Icon(Icons.psychology),
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'AI Match Score',
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
                            'out of 100',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),

                    // Summary
                    if (rating.summary != null) ...[
                      const Text(
                        'Tóm tắt',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Gap(8),
                      Text(
                        rating.summary!,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const Gap(16),
                    ],

                    // Strengths
                    if (rating.insights?['strengths'] != null) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Điểm mạnh',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                      const Gap(8),
                      ...(rating.insights!['strengths'] as List)
                          .take(3)
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Color(0xFF10B981),
                                  ),
                                  const Gap(8),
                                  Expanded(
                                    child: Text(
                                      e.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

// Resume Viewer Card
class _ResumeViewerCard extends StatelessWidget {
  final String? resumeUrl;

  const _ResumeViewerCard({this.resumeUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resume',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (resumeUrl != null)
                OutlinedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(resumeUrl!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Download'),
                ),
            ],
          ),
          const Gap(16),

          // PDF Viewer
          Expanded(
            child:
                resumeUrl != null
                    ? SfPdfViewer.network(resumeUrl!)
                    : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          const Gap(16),
                          Text(
                            'No resume uploaded',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Application Details',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gap(24),

          // Applied Position
          _DetailRow(label: 'Applied Position', value: job.title),
          const Gap(16),

          // Applied Date
          _DetailRow(
            label: 'Applied Date',
            value: DateFormatter.formatRelativeTime(application.appliedAt),
          ),
          const Gap(16),

          // Status
          _DetailRow(label: 'Current Status', value: application.status),
          const Gap(24),

          // Cover Letter
          if (application.coverLetter != null &&
              application.coverLetter!.isNotEmpty) ...[
            Text(
              'Cover Letter',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                application.coverLetter!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
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
          width: 150,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
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
        return const Color(0xFFF59E0B);
      case 'reviewing':
        return const Color(0xFF6366F1);
      case 'shortlisted':
        return const Color(0xFF8B5CF6);
      case 'accepted':
        return const Color(0xFF10B981);
      case 'rejected':
        return const Color(0xFFEF4444);
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getText(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _getColor(),
        ),
      ),
    );
  }
}
