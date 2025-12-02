import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/utils/date_formatter.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/ai_rating_viewmodel.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/applicant_detail_viewmodel.dart';
import 'package:job_connect/presentation/widgets/common/error_display.dart';
import 'package:job_connect/presentation/widgets/common/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

/// Applicant detail screen (Mobile-optimized & Modernized)
class ApplicantDetailScreen extends HookConsumerWidget {
  final String applicationId;

  const ApplicantDetailScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(
      applicantDetailViewModelProvider(applicationId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: detailState.when(
        initial: () => const LoadingIndicator(),
        loading: () => const LoadingIndicator(),
        loaded: (application, candidate, job) {
          return Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: 120,
                ), // Space for bottom bar
                child: Column(
                  children: [
                    // Modern Header
                    _ModernHeader(
                      candidate: candidate,
                      application: application,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // AI Insights
                          _AIInsightsCard(
                            applicationId: applicationId,
                            resumeUrl: application.resumeUrl,
                            job: job,
                          ),
                          const Gap(20),

                          // Application Details
                          _ApplicationDetailsCard(
                            application: application,
                            job: job,
                          ),
                          const Gap(20),

                          // Resume Download Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final uri = Uri.parse(application.resumeUrl);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                              icon: const Icon(CupertinoIcons.doc_text),
                              label: const Text('Xem CV đính kèm'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.textPrimary,
                                elevation: 0,
                                side: const BorderSide(color: AppColors.border),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Fixed Bottom Action Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _BottomActionBar(
                  application: application,
                  applicationId: applicationId,
                ),
              ),

              // Back Button (Custom)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          );
        },
        error:
            (message) => Scaffold(
              appBar: AppBar(title: const Text('Lỗi')),
              body: ErrorDisplay(
                message: message,
                onRetry: () {
                  ref.invalidate(
                    applicantDetailViewModelProvider(applicationId),
                  );
                },
              ),
            ),
      ),
    );
  }
}

class _ModernHeader extends StatelessWidget {
  final dynamic candidate;
  final dynamic application;

  const _ModernHeader({required this.candidate, required this.application});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 60,
        20,
        40,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Text(
                candidate.fullName?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const Gap(16),
          Text(
            candidate.fullName ?? 'Unknown',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.mail, color: Colors.white, size: 14),
                const Gap(6),
                Text(
                  candidate.email ?? 'N/A',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends ConsumerWidget {
  final dynamic application;
  final String applicationId;

  const _BottomActionBar({
    required this.application,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAccepted = application.status.toLowerCase() == 'accepted';
    final isRejected = application.status.toLowerCase() == 'rejected';

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed:
                  isRejected
                      ? null
                      : () async {
                        await ref
                            .read(
                              applicantDetailViewModelProvider(
                                applicationId,
                              ).notifier,
                            )
                            .rejectApplication();
                      },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Từ chối'),
            ),
          ),
          const Gap(16),
          Expanded(
            child: ElevatedButton(
              onPressed:
                  isAccepted
                      ? null
                      : () async {
                        await ref
                            .read(
                              applicantDetailViewModelProvider(
                                applicationId,
                              ).notifier,
                            )
                            .acceptApplication();
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Chấp nhận'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AIInsightsCard extends HookConsumerWidget {
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
    final isExpanded = useState(false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    CupertinoIcons.sparkles,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const Gap(12),
                const Text(
                  'Đánh giá AI',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Gap(20),
            aiState.when(
              initial: () => const SizedBox.shrink(),
              loading:
                  () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  ),
              error:
                  (message) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.exclamationmark_circle,
                          color: AppColors.error,
                        ),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            message,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
              notAnalyzed:
                  () => Center(
                    child: Column(
                      children: [
                        const Text(
                          'Chưa có dữ liệu phân tích',
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
                                          jobRequirements:
                                              job.requirements ?? '',
                                        );
                                  },
                          icon: const Icon(CupertinoIcons.sparkles),
                          label: const Text('Phân tích ngay'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              loaded:
                  (rating) => Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Circular Score
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CircularProgressIndicator(
                                  value: rating.overallScore / 10,
                                  strokeWidth: 8,
                                  backgroundColor: const Color(0xFFF3F4F6),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getScoreColor(rating.overallScore),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        (rating.overallScore * 10)
                                            .toStringAsFixed(0),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: _getScoreColor(
                                            rating.overallScore,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(20),
                          // Summary
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tổng quan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  rating.summary ?? 'Không có tóm tắt',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  maxLines: isExpanded.value ? null : 4,
                                  overflow:
                                      isExpanded.value
                                          ? null
                                          : TextOverflow.ellipsis,
                                ),
                                if ((rating.summary?.length ?? 0) > 100)
                                  InkWell(
                                    onTap:
                                        () =>
                                            isExpanded.value =
                                                !isExpanded.value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        isExpanded.value
                                            ? 'Thu gọn'
                                            : 'Xem thêm',
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8) return AppColors.success;
    if (score >= 6) return AppColors.warning;
    return AppColors.error;
  }
}

class _ApplicationDetailsCard extends StatelessWidget {
  final dynamic application;
  final dynamic job;

  const _ApplicationDetailsCard({required this.application, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin ứng tuyển',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Gap(20),
            _DetailRow(
              icon: CupertinoIcons.briefcase,
              label: 'Vị trí',
              value: job.title,
            ),
            const Gap(16),
            _DetailRow(
              icon: CupertinoIcons.time,
              label: 'Ngày nộp',
              value: DateFormatter.formatRelativeTime(application.appliedAt),
            ),
            const Gap(16),
            _DetailRow(
              icon: CupertinoIcons.tag,
              label: 'Trạng thái',
              value: _getStatusText(application.status),
              valueColor: _getStatusColor(application.status),
            ),
            if (application.coverLetter != null &&
                application.coverLetter!.isNotEmpty) ...[
              const Gap(20),
              const Divider(),
              const Gap(20),
              const Text(
                'Thư xin việc',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Gap(8),
              Text(
                application.coverLetter!,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      case 'shortlisted':
        return AppColors.primaryLight;
      default:
        return AppColors.textPrimary;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.textSecondary),
        ),
        const Gap(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
