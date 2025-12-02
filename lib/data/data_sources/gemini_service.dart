import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:job_connect/config/env_config.dart';
import 'package:job_connect/core/utils/logger.dart';

/// Gemini AI client for resume analysis
class GeminiService {
  GeminiService._();

  static GenerativeModel? _model;

  /// Initialize Gemini AI
  static void init() {
    try {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: EnvConfig.geminiApiKey,
      );
      AppLogger.info('Gemini AI initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Gemini AI', e, stackTrace);
      rethrow;
    }
  }

  /// Get model instance
  static GenerativeModel get model {
    if (_model == null) {
      throw Exception('Gemini has not been initialized. Call init() first.');
    }
    return _model!;
  }

  /// Analyze resume and return AI rating
  static Future<Map<String, dynamic>> analyzeResume({
    required String resumeText,
    required String jobTitle,
    required String jobRequirements,
  }) async {
    try {
      final prompt = '''
You are an expert HR recruiter. Analyze the following resume against the job requirements and provide a detailed assessment.

Job Title: $jobTitle

Job Requirements:
$jobRequirements

Resume/CV:
$resumeText

Please provide a JSON response with the following structure:
{
  "overall_score": <0-10>,
  "skill_match_score": <0-10>,
  "experience_score": <0-10>,
  "education_score": <0-10>,
  "summary": "<brief summary of the candidate's fit>",
  "strengths": ["<strength 1>", "<strength 2>", ...],
  "weaknesses": ["<weakness 1>", "<weakness 2>", ...],
  "recommendations": ["<recommendation 1>", "<recommendation 2>", ...]
}

Provide scores based on:
- overall_score: Overall fit for the position
- skill_match_score: How well skills match job requirements
- experience_score: Relevance and quality of experience
- education_score: Education background relevance

Return ONLY valid JSON, no additional text.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception('No response from Gemini AI');
      }

      // Parse JSON response
      final jsonText = response.text!.trim();
      // Remove markdown code blocks if present
      final cleanJson =
          jsonText.replaceAll('```json', '').replaceAll('```', '').trim();

      // For now, return raw response (will be parsed in repository layer)
      return {
        'raw_response': cleanJson,
        'analyzed_at': DateTime.now().toIso8601String(),
      };
    } catch (e, stackTrace) {
      AppLogger.error('Failed to analyze resume with Gemini', e, stackTrace);
      rethrow;
    }
  }

  /// Extract text from resume URL (placeholder - actual implementation would use OCR/PDF parsing)
  static Future<String> extractTextFromResume(String resumeUrl) async {
    // TODO: Implement actual text extraction from PDF/DOCX
    // For now, return placeholder
    AppLogger.warning('Resume text extraction not yet implemented');
    return 'Resume text extraction pending implementation';
  }
}
