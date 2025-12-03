import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/data/models/ai_rating_model.dart';
import 'package:job_connect/data/services/ai_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// AI rating repository for AI-powered resume analysis
class AiRatingRepository {
  final SupabaseClient _client;
  final AiService _aiService;

  AiRatingRepository(this._client, this._aiService);

  /// Analyze application and create AI rating
  Future<Either<String, AiRatingModel>> analyzeApplication({
    required String applicationId,
    required String resumeUrl,
    required String jobTitle,
    required String jobDescription,
    required String jobRequirements,
  }) async {
    try {
      // 1. Download resume file
      AppLogger.info('Downloading resume from: $resumeUrl');
      final response = await http.get(Uri.parse(resumeUrl));

      if (response.statusCode != 200) {
        return left('Không thể tải xuống file CV');
      }

      final pdfBytes = response.bodyBytes;

      // 2. Extract text from PDF
      AppLogger.info('Extracting text from PDF...');
      final resumeText = _aiService.extractTextFromPdf(pdfBytes);

      if (resumeText.trim().isEmpty) {
        return left(
          'Không thể đọc nội dung từ file CV (file trống hoặc định dạng không hỗ trợ)',
        );
      }

      // 3. Analyze with Gemini
      AppLogger.info('Analyzing with Gemini...');
      final analysisResult = await _aiService.analyzeApplication(
        resumeText: resumeText,
        jobTitle: jobTitle,
        jobDescription: jobDescription,
        jobRequirements: jobRequirements,
      );

      // 4. Save to database
      final ratingData = {
        'application_id': applicationId,
        'overall_score': analysisResult.overallScore,
        'skill_match_score': analysisResult.skillMatchScore,
        'experience_score': analysisResult.experienceScore,
        'education_score': analysisResult.educationScore,
        'summary': analysisResult.summary,
        'insights': analysisResult.toInsightsJson(),
        'analyzed_at': DateTime.now().toIso8601String(),
      };

      // Check if rating already exists, update if so
      final existing =
          await _client
              .from('ai_ratings')
              .select()
              .eq('application_id', applicationId)
              .maybeSingle();

      Map<String, dynamic> data;
      if (existing != null) {
        data =
            await _client
                .from('ai_ratings')
                .update(ratingData)
                .eq('application_id', applicationId)
                .select()
                .single();
      } else {
        data =
            await _client
                .from('ai_ratings')
                .insert(ratingData)
                .select()
                .single();
      }

      final rating = AiRatingModel.fromJson(data);
      AppLogger.info(
        'Created/Updated AI rating for application: $applicationId',
      );
      return right(rating);
    } catch (e, stackTrace) {
      AppLogger.error('Error analyzing application', e, stackTrace);
      return left('Lỗi khi phân tích hồ sơ: ${e.toString()}');
    }
  }

  /// Get AI rating by application ID
  Future<Either<String, AiRatingModel?>> getRatingByApplication(
    String applicationId,
  ) async {
    try {
      final data =
          await _client
              .from('ai_ratings')
              .select()
              .eq('application_id', applicationId)
              .maybeSingle();

      if (data == null) {
        return right(null);
      }

      final rating = AiRatingModel.fromJson(data);
      return right(rating);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching AI rating', e, stackTrace);
      return left('Không thể tải đánh giá AI');
    }
  }
}
