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
import 'package:data_table_2/data_table_2.dart';

/// Applicant list screen with Table View
class ApplicantListScreen extends HookConsumerWidget {
  final String jobId;

  const ApplicantListScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicantState = ref.watch(applicantListViewModelProvider(jobId));

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Quản lý ứng viên'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(applicantListViewModelProvider(jobId).notifier)
                  .refresh();
            },
          ),
          const Gap(16),
        ],
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
                    Icons.people_outline,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const Gap(16),
                  Text(
                    'Chưa có ứng viên nào',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return _ApplicantTable(applications: applications, jobId: jobId);
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

class _ApplicantTable extends ConsumerStatefulWidget {
  final List<ApplicationModel> applications;
  final String jobId;

  const _ApplicantTable({required this.applications, required this.jobId});

  @override
  ConsumerState<_ApplicantTable> createState() => _ApplicantTableState();
}

class _ApplicantTableState extends ConsumerState<_ApplicantTable> {
  String _selectedFilter = 'all';
  String _searchQuery = '';

  List<ApplicationModel> get _filteredApplications {
    var filtered = widget.applications;

    // Filter by status
    if (_selectedFilter != 'all') {
      filtered =
          filtered
              .where((app) => app.status.toLowerCase() == _selectedFilter)
              .toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((app) {
            return app.candidateId.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                (app.coverLetter?.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ??
                    false);
          }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps = _filteredApplications;

    return Column(
      children: [
        // Filters and Search
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm ứng viên...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const Gap(16),

              // Filter chips
              Wrap(
                spacing: 8,
                children: [
                  _FilterChip(
                    label: 'Tất cả',
                    count: widget.applications.length,
                    isSelected: _selectedFilter == 'all',
                    onTap: () => setState(() => _selectedFilter = 'all'),
                  ),
                  _FilterChip(
                    label: 'Chờ xử lý',
                    count:
                        widget.applications
                            .where((a) => a.status.toLowerCase() == 'pending')
                            .length,
                    isSelected: _selectedFilter == 'pending',
                    onTap: () => setState(() => _selectedFilter = 'pending'),
                    color: const Color(0xFFF59E0B),
                  ),
                  _FilterChip(
                    label: 'Đang xem xét',
                    count:
                        widget.applications
                            .where((a) => a.status.toLowerCase() == 'reviewing')
                            .length,
                    isSelected: _selectedFilter == 'reviewing',
                    onTap: () => setState(() => _selectedFilter = 'reviewing'),
                    color: const Color(0xFF6366F1),
                  ),
                  _FilterChip(
                    label: 'Đã lọt vòng',
                    count:
                        widget.applications
                            .where(
                              (a) => a.status.toLowerCase() == 'shortlisted',
                            )
                            .length,
                    isSelected: _selectedFilter == 'shortlisted',
                    onTap:
                        () => setState(() => _selectedFilter = 'shortlisted'),
                    color: const Color(0xFF8B5CF6),
                  ),
                  _FilterChip(
                    label: 'Đã chấp nhận',
                    count:
                        widget.applications
                            .where((a) => a.status.toLowerCase() == 'accepted')
                            .length,
                    isSelected: _selectedFilter == 'accepted',
                    onTap: () => setState(() => _selectedFilter = 'accepted'),
                    color: const Color(0xFF10B981),
                  ),
                  _FilterChip(
                    label: 'Đã từ chối',
                    count:
                        widget.applications
                            .where((a) => a.status.toLowerCase() == 'rejected')
                            .length,
                    isSelected: _selectedFilter == 'rejected',
                    onTap: () => setState(() => _selectedFilter = 'rejected'),
                    color: const Color(0xFFEF4444),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Table
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 24,
              minWidth: 900,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
              headingRowHeight: 56,
              dataRowHeight: 72,
              columns: const [
                DataColumn2(
                  label: Text(
                    'Ứng viên',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(
                    'Ngày ứng tuyển',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Trạng thái',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'AI Score',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Hành động',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  size: ColumnSize.L,
                ),
              ],
              rows:
                  filteredApps.map((app) {
                    return DataRow2(
                      cells: [
                        // Candidate info
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(
                                  0xFF6366F1,
                                ).withOpacity(0.1),
                                child: Text(
                                  app.candidateId.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFF6366F1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ID: ${app.candidateId.substring(0, 8)}...',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (app.coverLetter != null &&
                                        app.coverLetter!.isNotEmpty)
                                      Text(
                                        app.coverLetter!.length > 40
                                            ? '${app.coverLetter!.substring(0, 40)}...'
                                            : app.coverLetter!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Applied date
                        DataCell(
                          Text(DateFormatter.formatRelativeTime(app.appliedAt)),
                        ),

                        // Status
                        DataCell(_StatusBadge(status: app.status)),

                        // AI Score (placeholder)
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 14,
                                  color: Color(0xFF10B981),
                                ),
                                Gap(4),
                                Text(
                                  '85',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Actions
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Status dropdown
                              _StatusDropdown(
                                currentStatus: app.status,
                                onChanged: (newStatus) async {
                                  await ref
                                      .read(
                                        applicantListViewModelProvider(
                                          widget.jobId,
                                        ).notifier,
                                      )
                                      .updateStatus(app.id, newStatus);
                                },
                              ),
                              const Gap(8),

                              // View details
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 20,
                                ),
                                onPressed: () {
                                  context.go(
                                    '/recruiter/jobs/${widget.jobId}/applicants/${app.id}',
                                  );
                                },
                                tooltip: 'Xem chi tiết',
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
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
    final chipColor = color ?? const Color(0xFF6366F1);

    return Material(
      color: isSelected ? chipColor.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? chipColor : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? chipColor : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? chipColor : AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getText(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getColor(),
        ),
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  final String currentStatus;
  final Function(String) onChanged;

  const _StatusDropdown({required this.currentStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: currentStatus.toLowerCase(),
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, size: 20),
        items: const [
          DropdownMenuItem(value: 'pending', child: Text('Chờ xử lý')),
          DropdownMenuItem(value: 'reviewing', child: Text('Đang xem xét')),
          DropdownMenuItem(value: 'shortlisted', child: Text('Đã lọt vòng')),
          DropdownMenuItem(value: 'accepted', child: Text('Chấp nhận')),
          DropdownMenuItem(value: 'rejected', child: Text('Từ chối')),
        ],
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}
