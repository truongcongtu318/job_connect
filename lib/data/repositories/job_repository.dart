import 'package:fpdart/fpdart.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/models/company_model.dart';
import 'package:job_connect/data/models/job_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Job repository for job-related operations
class JobRepository {
  final SupabaseClient _client;

  JobRepository(this._client);

  /// Get all jobs with optional filters and pagination
  Future<Either<String, List<JobModel>>> getJobs({
    int page = 0,
    int limit = 20,
    String? searchQuery,
    String? location,
    String? jobType,
    String? category,
    double? minSalary,
    double? maxSalary,
  }) async {
    try {
      // Start building the query
      var query = _client
          .from('jobs')
          .select('*, companies(*)') // Join with companies table
          .eq('status', 'active');

      // Apply filters
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.ilike('title', '%$searchQuery%');
      }

      if (location != null && location.isNotEmpty) {
        query = query.ilike('location', '%$location%');
      }

      if (jobType != null && jobType.isNotEmpty) {
        query = query.eq('job_type', jobType);
      }

      if (minSalary != null) {
        query = query.gte('salary_min', minSalary);
      }

      if (maxSalary != null) {
        query = query.lte('salary_max', maxSalary);
      }

      // Apply sorting and pagination at the end
      final data = await query
          .order('created_at', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);

      final jobs =
          (data as List).map((json) {
            var job = JobModel.fromJson(json);
            // Map company data if present
            if (json['companies'] != null) {
              job = job.copyWith(
                company: CompanyModel.fromJson(json['companies']),
              );
            }
            return job;
          }).toList();

      // Filter by category if provided (client-side filtering for now)
      if (category != null && category.isNotEmpty && category != 'Tất cả') {
        final filteredJobs =
            jobs.where((job) {
              // Simple keyword matching for category
              final title = job.title.toLowerCase();
              final cat = category.toLowerCase();
              return title.contains(cat);
            }).toList();
        return right(filteredJobs);
      }

      return right(jobs);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching jobs', e, stackTrace);
      return left('Không thể tải danh sách việc làm');
    }
  }

  /// Get job detail by ID
  Future<Either<String, JobModel>> getJobById(String jobId) async {
    try {
      final data =
          await _client
              .from('jobs')
              .select('*, companies(*)')
              .eq('id', jobId)
              .single();

      var job = JobModel.fromJson(data);
      if (data['companies'] != null) {
        job = job.copyWith(company: CompanyModel.fromJson(data['companies']));
      }

      return right(job);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching job detail', e, stackTrace);
      return left('Không thể tải chi tiết việc làm');
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
    required String companyId,
    required String title,
    required String description,
    required String requirements,
    String? benefits,
    String? location,
    String? jobType,
    double? salaryMin,
    double? salaryMax,
    String status = 'active',
  }) async {
    try {
      final jobData = {
        'recruiter_id': recruiterId,
        'company_id': companyId,
        'title': title,
        'description': description,
        'requirements': requirements,
        'benefits': benefits,
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

  /// Get saved jobs for user
  Future<Either<String, List<JobModel>>> getSavedJobs(String userId) async {
    try {
      final data = await _client
          .from('saved_jobs')
          .select('jobs(*, companies(*))')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final jobs =
          (data as List).map((item) {
            final jobJson = item['jobs'] as Map<String, dynamic>;
            var job = JobModel.fromJson(jobJson);
            // Map company data if present
            if (jobJson['companies'] != null) {
              job = job.copyWith(
                company: CompanyModel.fromJson(jobJson['companies']),
              );
            }
            return job;
          }).toList();

      AppLogger.info('Fetched ${jobs.length} saved jobs for user: $userId');
      return right(jobs);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching saved jobs', e, stackTrace);
      return left('Không thể tải danh sách việc làm đã lưu');
    }
  }

  /// Save job
  Future<Either<String, void>> saveJob(String userId, String jobId) async {
    try {
      await _client.from('saved_jobs').insert({
        'user_id': userId,
        'job_id': jobId,
      });
      AppLogger.info('Saved job $jobId for user $userId');
      return right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Error saving job', e, stackTrace);
      return left('Không thể lưu việc làm');
    }
  }

  /// Unsave job
  Future<Either<String, void>> unsaveJob(String userId, String jobId) async {
    try {
      await _client
          .from('saved_jobs')
          .delete()
          .eq('user_id', userId)
          .eq('job_id', jobId);
      AppLogger.info('Unsaved job $jobId for user $userId');
      return right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Error unsaving job', e, stackTrace);
      return left('Không thể bỏ lưu việc làm');
    }
  }

  /// Check if job is saved
  Future<Either<String, bool>> isJobSaved(String userId, String jobId) async {
    try {
      final data =
          await _client
              .from('saved_jobs')
              .select()
              .eq('user_id', userId)
              .eq('job_id', jobId)
              .maybeSingle();

      return right(data != null);
    } catch (e, stackTrace) {
      AppLogger.error('Error checking saved job status', e, stackTrace);
      return left('Lỗi kiểm tra trạng thái lưu');
    }
  }

  /// Get all job titles for category extraction
  Future<Either<String, List<String>>> getAllJobTitles() async {
    try {
      final data = await _client.from('jobs').select('title');
      final titles = (data as List).map((e) => e['title'] as String).toList();
      return right(titles);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching job titles', e, stackTrace);
      return left('Lỗi tải danh mục');
    }
  }
}
