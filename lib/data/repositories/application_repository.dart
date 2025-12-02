import 'package:fpdart/fpdart.dart';
import 'package:job_connect/data/data_sources/supabase_service.dart';
import 'package:job_connect/data/models/application_model.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Application repository for application-related operations
class ApplicationRepository {
  final SupabaseClient _client = SupabaseService.client;

  /// Get applications by candidate
  Future<Either<String, List<ApplicationModel>>> getApplicationsByCandidate(
    String candidateId,
  ) async {
    try {
      final data = await _client
          .from('applications')
          .select('*, jobs(*, companies(*))')
          .eq('candidate_id', candidateId)
          .order('applied_at', ascending: false);

      final applications =
          (data as List).map((json) {
            if (json['jobs'] != null) {
              // Map nested job data
              var jobJson = json['jobs'] as Map<String, dynamic>;
              if (jobJson['companies'] != null) {
                jobJson['company'] = jobJson['companies'];
              }
              json['job'] = jobJson;
            }
            return ApplicationModel.fromJson(json);
          }).toList();

      AppLogger.info(
        'Fetched ${applications.length} applications for candidate',
      );
      return right(applications);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching applications', e, stackTrace);
      return left('Không thể tải danh sách đơn ứng tuyển');
    }
  }

  /// Get applications by job
  Future<Either<String, List<ApplicationModel>>> getApplicationsByJob(
    String jobId,
  ) async {
    try {
      final data = await _client
          .from('applications')
          .select()
          .eq('job_id', jobId)
          .order('applied_at', ascending: false);

      final applications =
          (data as List)
              .map((json) => ApplicationModel.fromJson(json))
              .toList();

      AppLogger.info('Fetched ${applications.length} applications for job');
      return right(applications);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching job applications', e, stackTrace);
      return left('Không thể tải danh sách ứng viên');
    }
  }

  /// Get application by ID
  Future<Either<String, ApplicationModel>> getApplicationById(
    String applicationId,
  ) async {
    try {
      final data =
          await _client
              .from('applications')
              .select()
              .eq('id', applicationId)
              .single();

      final application = ApplicationModel.fromJson(data);
      AppLogger.info('Fetched application: $applicationId');
      return right(application);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching application', e, stackTrace);
      return left('Không thể tải thông tin đơn ứng tuyển');
    }
  }

  /// Create application
  Future<Either<String, ApplicationModel>> createApplication({
    required String jobId,
    required String candidateId,
    required String resumeUrl,
    String? coverLetter,
  }) async {
    try {
      final applicationData = {
        'job_id': jobId,
        'candidate_id': candidateId,
        'resume_url': resumeUrl,
        'cover_letter': coverLetter,
        'status': 'pending',
        'applied_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final data =
          await _client
              .from('applications')
              .insert(applicationData)
              .select()
              .single();

      final application = ApplicationModel.fromJson(data);
      AppLogger.info('Created application: ${application.id}');
      return right(application);
    } catch (e, stackTrace) {
      AppLogger.error('Error creating application', e, stackTrace);
      return left('Không thể gửi đơn ứng tuyển');
    }
  }

  /// Update application status
  Future<Either<String, ApplicationModel>> updateApplicationStatus({
    required String applicationId,
    required String status,
  }) async {
    try {
      final data =
          await _client
              .from('applications')
              .update({
                'status': status,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', applicationId)
              .select()
              .maybeSingle();

      if (data == null) {
        return left(
          'Không tìm thấy đơn ứng tuyển hoặc không có quyền cập nhật',
        );
      }

      final application = ApplicationModel.fromJson(data);
      AppLogger.info('Updated application status: $applicationId -> $status');
      return right(application);
    } catch (e, stackTrace) {
      AppLogger.error('Error updating application status', e, stackTrace);
      return left('Không thể cập nhật trạng thái đơn ứng tuyển');
    }
  }

  /// Upload resume to Supabase Storage
  Future<Either<String, String>> uploadResume({
    required String userId,
    required dynamic file,
    required String fileName,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '$userId/${timestamp}_$fileName';

      // Upload file to storage
      // Supabase accepts both File and Uint8List
      await _client.storage
          .from('resumes')
          .uploadBinary(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get public URL
      final url = _client.storage.from('resumes').getPublicUrl(path);

      AppLogger.info('Resume uploaded: $path');
      return right(url);
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading resume', e, stackTrace);
      return left('Không thể tải lên CV. Vui lòng thử lại');
    }
  }
}
