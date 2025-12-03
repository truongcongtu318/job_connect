import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:job_connect/config/env_config.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Result from AI analysis
class AiAnalysisResult {
  final double overallScore;
  final double skillMatchScore;
  final double experienceScore;
  final double educationScore;
  final String summary;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> matchingKeywords;
  final List<String> missingKeywords;

  AiAnalysisResult({
    required this.overallScore,
    required this.skillMatchScore,
    required this.experienceScore,
    required this.educationScore,
    required this.summary,
    required this.strengths,
    required this.weaknesses,
    required this.matchingKeywords,
    required this.missingKeywords,
  });

  factory AiAnalysisResult.fromJson(Map<String, dynamic> json) {
    return AiAnalysisResult(
      overallScore: (json['overall_score'] as num).toDouble(),
      skillMatchScore: (json['skill_match_score'] as num).toDouble(),
      experienceScore: (json['experience_score'] as num).toDouble(),
      educationScore: (json['education_score'] as num).toDouble(),
      summary: json['summary'] as String,
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
      matchingKeywords: List<String>.from(json['matching_keywords'] ?? []),
      missingKeywords: List<String>.from(json['missing_keywords'] ?? []),
    );
  }

  Map<String, dynamic> toInsightsJson() {
    return {
      'strengths': strengths,
      'weaknesses': weaknesses,
      'matching_keywords': matchingKeywords,
      'missing_keywords': missingKeywords,
    };
  }
}

/// Service to handle AI operations using Gemini
class AiService {
  late final GenerativeModel _model;

  AiService() {
    // Using gemini-1.5-flash as requested (assuming user meant 1.5, as 2.5 doesn't exist publicly yet)
    // Removing responseMimeType: 'application/json' to avoid potential compatibility issues
    // We will parse JSON manually from the text response
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: EnvConfig.geminiApiKey,
    );
  }

  /// Extract text from PDF bytes
  String extractTextFromPdf(Uint8List pdfBytes) {
    try {
      final PdfDocument document = PdfDocument(inputBytes: pdfBytes);
      String text = PdfTextExtractor(document).extractText();
      document.dispose();
      AppLogger.info('Extracted PDF Text: $text');
      return text;
    } catch (e, stackTrace) {
      AppLogger.error('Error extracting text from PDF', e, stackTrace);
      throw Exception('Failed to extract text from resume');
    }
  }

  /// Analyze application against job description
  Future<AiAnalysisResult> analyzeApplication({
    required String resumeText,
    required String jobTitle,
    required String jobDescription,
    required String jobRequirements,
  }) async {
    try {
      final prompt = '''
You are an EXPERT HR evaluator with a STRICT and OBJECTIVE scoring system. Your job is to accurately assess how well a candidate matches a specific job position.

=== JOB POSITION ===
Title: $jobTitle

Description:
$jobDescription

Requirements:
$jobRequirements

=== CANDIDATE'S RESUME ===
$resumeText

=== CRITICAL SCORING RULES ===
You MUST follow these rules strictly. Scores are 0-100 INTEGERS:

1. SKILL MATCHING (skill_match_score 0-100):
   - 0-30: No match or completely different skills (e.g., Java dev for Data Analyst role)
   - 31-50: Less than 50% of required skills present
   - 51-70: 50-75% of required skills present
   - 71-90: 75-90% match with most critical skills
   - 91-100: 90%+ match, has all critical skills

2. EXPERIENCE MATCHING (experience_score 0-100):
   - 0-30: Completely different field/industry
   - 31-50: Related field but different role
   - 51-70: Same field with some relevant experience
   - 71-90: Direct relevant experience matching requirements
   - 91-100: Extensive relevant experience exceeding requirements

3. EDUCATION MATCHING (education_score 0-100):
   - 0-30: Unrelated educational background
   - 31-50: Partially related education
   - 51-70: Matching field of study
   - 71-90: Matching level and field
   - 91-100: Exceeds education requirements

4. OVERALL SCORE CALCULATION:
   - Must be REALISTIC average of skill, experience, and education scores
   - If candidate is from COMPLETELY DIFFERENT field, overall score MUST be 0-40
   - PENALIZE heavily for major skill mismatches
   - DO NOT inflate scores

5. FORBIDDEN BEHAVIORS:
   - DO NOT give high scores just because resume looks professional
   - DO NOT assume skills not explicitly mentioned in resume
   - DO NOT give benefit of doubt for missing critical skills
   - DO NOT score based on potential - only score based on ACTUAL match

=== REQUIRED JSON OUTPUT ===
Return ONLY valid JSON with this EXACT structure:
{
  "overall_score": <0-100 integer>,
  "skill_match_score": <0-100 integer>,
  "experience_score": <0-100 integer>,
  "education_score": <0-100 integer>,
  "summary": "<2-3 sentences explaining overall match and major gaps in VIETNAMESE language>",
  "strengths": ["<specific strength 1 in English>", "<specific strength 2 in English>", "<specific strength 3 in English>"],
  "weaknesses": ["<critical weakness 1 in English>", "<critical weakness 2 in English>", "<critical weakness 3 in English>"],
  "matching_keywords": ["<skill/keyword that matches>", ...],
  "missing_keywords": ["<required skill/keyword not found in resume>", ...]
}

IMPORTANT: Be HONEST and OBJECTIVE. A mismatch is NOT a failure - it helps recruiters find the RIGHT candidate.
Return ONLY the JSON object, no markdown, no explanations.
''';

      // Log the prompt for debugging
      print('\n========================================');
      print('🤖 GEMINI AI PROMPT');
      print('========================================');
      print(prompt);
      print('========================================\n');

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw Exception('Empty response from AI');
      }

      var text = response.text!;

      // Log the raw response
      print('\n========================================');
      print('✅ GEMINI AI RESPONSE');
      print('========================================');
      print(text);
      print('========================================\n');

      // Clean markdown code blocks if present
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();

      final jsonResult = jsonDecode(text);

      // Convert scores from 0-100 to 0-10 scale
      jsonResult['overall_score'] = (jsonResult['overall_score'] / 10).round();
      jsonResult['skill_match_score'] =
          (jsonResult['skill_match_score'] / 10).round();
      jsonResult['experience_score'] =
          (jsonResult['experience_score'] / 10).round();
      jsonResult['education_score'] =
          (jsonResult['education_score'] / 10).round();

      // Safety clamp to ensure scores are within 0-10 range
      jsonResult['overall_score'] = jsonResult['overall_score'].clamp(0, 10);
      jsonResult['skill_match_score'] = jsonResult['skill_match_score'].clamp(
        0,
        10,
      );
      jsonResult['experience_score'] = jsonResult['experience_score'].clamp(
        0,
        10,
      );
      jsonResult['education_score'] = jsonResult['education_score'].clamp(
        0,
        10,
      );

      // Log final scores
      print('\n📊 FINAL SCORES (0-10 scale):');
      print('Overall: ${jsonResult['overall_score']}');
      print('Skill Match: ${jsonResult['skill_match_score']}');
      print('Experience: ${jsonResult['experience_score']}');
      print('Education: ${jsonResult['education_score']}\n');

      return AiAnalysisResult.fromJson(jsonResult);
    } catch (e, stackTrace) {
      AppLogger.error('Error analyzing application with AI', e, stackTrace);
      throw Exception('Failed to analyze application: ${e.toString()}');
    }
  }
}
