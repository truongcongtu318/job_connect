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
      You are an expert HR evaluator AI. Your task is to assess how well the candidate's resume matches the job.

Follow these rules strictly:
- Do NOT fabricate information not present in the resume.
- Base all scoring only on the provided content.
- All scores must be integers from 0 to 100.
- The output MUST be valid JSON only, with no additional text.
- If any section of input is missing or vague, still produce reasonable scores based on available information.

JOB TITLE:
$jobTitle

JOB DESCRIPTION:
$jobDescription

JOB REQUIREMENTS:
$jobRequirements

RESUME TEXT:
$resumeText

Evaluate the fit and provide the response in this exact JSON format:
{
  "overall_score": <0-100>,
  "skill_match_score": <0-100>,
  "experience_score": <0-100>,
  "education_score": <0-100>,
  "summary": "<max_3_sentences>",
  "strengths": ["<strength_1>", "<strength_2>", ...],
  "weaknesses": ["<weakness_1>", "<weakness_2>", ...],
  "matching_keywords": ["<keyword_1>", ...],
  "missing_keywords": ["<keyword_1>", ...]
}
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw Exception('Empty response from AI');
      }

      var text = response.text!;
      // Clean markdown code blocks if present
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();

      final jsonResult = jsonDecode(text);

      // Safety clamp to ensure scores are within 0-10 range
      if (jsonResult['overall_score'] > 10) jsonResult['overall_score'] = 10;
      if (jsonResult['skill_match_score'] > 10)
        jsonResult['skill_match_score'] = 10;
      if (jsonResult['experience_score'] > 10)
        jsonResult['experience_score'] = 10;
      if (jsonResult['education_score'] > 10)
        jsonResult['education_score'] = 10;

      return AiAnalysisResult.fromJson(jsonResult);
    } catch (e, stackTrace) {
      AppLogger.error('Error analyzing application with AI', e, stackTrace);
      throw Exception('Failed to analyze application: ${e.toString()}');
    }
  }
}
