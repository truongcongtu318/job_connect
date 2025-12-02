import 'package:fpdart/fpdart.dart';
import 'package:job_connect/data/data_sources/supabase_service.dart';
import 'package:job_connect/data/models/job_model.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Job repository for job-related operations
class JobRepository {
  final SupabaseClient _client = SupabaseService.client;

  /// Get all active jobs with pagination
  Future<Either<String, List<JobModel>>> getJobs({
    int page = 0,
    int limit = 20,
    String? searchQuery,
  }) async {
    try {
      var query = _client
          .from('jobs')
          .select()
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);

      final data = await query;
      var jobs = (data as List).map((json) => JobModel.fromJson(json)).toList();

      // Client-side filtering if search query is provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        jobs =
            jobs.where((job) {
              return job.title.toLowerCase().contains(lowerQuery) ||
                  job.description.toLowerCase().contains(lowerQuery);
            }).toList();
      }

      AppLogger.info('Fetched ${jobs.length} jobs');
      return right(jobs);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching jobs', e, stackTrace);
      return left('Không thể tải danh sách công việc');
    }
  }

  /// Get job by ID
  Future<Either<String, JobModel>> getJobById(String jobId) async {
    try {
      final data = await _client.from('jobs').select().eq('id', jobId).single();

      final job = JobModel.fromJson(data);
      AppLogger.info('Fetched job: ${job.title}');
      return right(job);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching job', e, stackTrace);
      return left('Không thể tải thông tin công việc');
    }
  }

  /// Get jobs by recruiter
  Future<Either<String, List<JobModel>>> getJobsByRecruiter(
    String recruiterId,
  ) async {
    try {
      final data = await _client
          .from('jobs')
          .select()
          .eq('recruiter_id', recruiterId)
          .order('created_at', ascending: false);

      final jobs =
          (data as List).map((json) => JobModel.fromJson(json)).toList();
      AppLogger.info('Fetched ${jobs.length} jobs for recruiter: $recruiterId');
      return right(jobs);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching recruiter jobs', e, stackTrace);
      return left('Không thể tải danh sách công việc');
    }
  }

  /// Create a new job
  Future<Either<String, JobModel>> createJob({
    required String recruiterId,
    required String title,
    required String description,
    required String requirements,
    String? location,
    String? jobType,
    double? salaryMin,
    double? salaryMax,
    String status = 'active',
  }) async {
    try {
      final jobData = {
        'recruiter_id': recruiterId,
        'title': title,
        'description': description,
        'requirements': requirements,
        'location': location,
        'job_type': jobType,
        'salary_min': salaryMin,
        'salary_max': salaryMax,
        'status': status,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final data = await _client.from('jobs').insert(jobData).select().single();

      final job = JobModel.fromJson(data);
      AppLogger.info('Created job: ${job.title}');
      return right(job);
    } catch (e, stackTrace) {
      AppLogger.error('Error creating job', e, stackTrace);
      return left('Không thể tạo tin tuyển dụng');
    }
  }

  /// Update job
  Future<Either<String, JobModel>> updateJob({
    required String jobId,
    String? title,
    String? description,
    String? requirements,
    String? location,
    String? jobType,
    double? salaryMin,
    double? salaryMax,
    String? status,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (requirements != null) updates['requirements'] = requirements;
      if (location != null) updates['location'] = location;
      if (jobType != null) updates['job_type'] = jobType;
      if (salaryMin != null) updates['salary_min'] = salaryMin;
      if (salaryMax != null) updates['salary_max'] = salaryMax;
      if (status != null) updates['status'] = status;

      final data =
          await _client
              .from('jobs')
              .update(updates)
              .eq('id', jobId)
              .select()
              .single();

      final job = JobModel.fromJson(data);
      AppLogger.info('Updated job: ${job.title}');
      return right(job);
    } catch (e, stackTrace) {
      AppLogger.error('Error updating job', e, stackTrace);
      return left('Không thể cập nhật tin tuyển dụng');
    }
  }

  /// Delete job
  Future<Either<String, void>> deleteJob(String jobId) async {
    try {
      await _client.from('jobs').delete().eq('id', jobId);

      AppLogger.info('Deleted job: $jobId');
      return right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting job', e, stackTrace);
      return left('Không thể xóa tin tuyển dụng');
    }
  }
}
