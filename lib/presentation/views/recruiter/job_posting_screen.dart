import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/constants/app_colors.dart';
import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_viewmodel.dart';

/// Job posting screen for recruiters
class JobPostingScreen extends HookConsumerWidget {
  const JobPostingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final recruiterId = authState.whenOrNull(authenticated: (user) => user.id);

    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final requirementsController = useTextEditingController();
    final benefitsController = useTextEditingController();
    final locationController = useTextEditingController();
    final salaryMinController = useTextEditingController();
    final salaryMaxController = useTextEditingController();

    final selectedJobType = useState<String>('full-time');
    final isLoading = useState(false);

    final jobTypes = [
      {'value': 'full-time', 'label': 'Toàn thời gian'},
      {'value': 'part-time', 'label': 'Bán thời gian'},
      {'value': 'contract', 'label': 'Hợp đồng'},
      {'value': 'internship', 'label': 'Thực tập'},
    ];

    Future<void> handleSubmit() async {
      if (recruiterId == null) return;

      // Validation
      if (titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập tiêu đề công việc')),
        );
        return;
      }

      if (descriptionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập mô tả công việc')),
        );
        return;
      }

      if (requirementsController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập yêu cầu công việc')),
        );
        return;
      }

      isLoading.value = true;

      try {
        final jobRepo = ref.read(jobRepositoryProvider);

        final result = await jobRepo.createJob(
          recruiterId: recruiterId,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          requirements: requirementsController.text.trim(),
          location:
              locationController.text.trim().isNotEmpty
                  ? locationController.text.trim()
                  : null,
          jobType: selectedJobType.value,
          salaryMin:
              salaryMinController.text.trim().isNotEmpty
                  ? double.tryParse(salaryMinController.text.trim())
                  : null,
          salaryMax:
              salaryMaxController.text.trim().isNotEmpty
                  ? double.tryParse(salaryMaxController.text.trim())
                  : null,
          status: 'active',
        );

        result.fold(
          (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error)));
          },
          (job) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đăng tin thành công!')),
            );
            context.pop();
          },
        );
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Đăng tin tuyển dụng'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Tiêu đề công việc',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'VD: Senior Flutter Developer',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Gap(20),

            // Job Type
            Text(
              'Loại hình công việc',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedJobType.value,
                  isExpanded: true,
                  items:
                      jobTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type['value'] as String,
                          child: Text(type['label'] as String),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedJobType.value = value;
                    }
                  },
                ),
              ),
            ),
            const Gap(20),

            // Location
            Text(
              'Địa điểm',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'VD: Hà Nội, Việt Nam',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Gap(20),

            // Salary Range
            Text(
              'Mức lương (VND)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: salaryMinController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Từ',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: TextField(
                    controller: salaryMaxController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Đến',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),

            // Description
            Text(
              'Mô tả công việc',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Nhập mô tả chi tiết về công việc...',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Gap(20),

            // Requirements
            Text(
              'Yêu cầu công việc',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            TextField(
              controller: requirementsController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Nhập yêu cầu về kỹ năng, kinh nghiệm...',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Gap(20),

            // Benefits (Optional)
            Text(
              'Quyền lợi (Tùy chọn)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            TextField(
              controller: benefitsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Nhập các quyền lợi cho ứng viên...',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Gap(32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading.value ? null : handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    isLoading.value
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text(
                          'Đăng tin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
