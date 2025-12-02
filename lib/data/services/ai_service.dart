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
      You are an expert HR AI assistant. Analyze the following resume against the job description.

      JOB TITLE: $jobTitle
      
      JOB DESCRIPTION:
      $jobDescription
      
      JOB REQUIREMENTS:
      $jobRequirements

      RESUME TEXT:
      $resumeText

      Analyze the fit and provide the output in the following JSON format (do not include markdown code blocks):
      {
        "overall_score": <number_0_to_100>,
        "skill_match_score": <number_0_to_100>,
        "experience_score": <number_0_to_100>,
        "education_score": <number_0_to_100>,
        "summary": "<short_summary_of_fit_max_3_sentences>",
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
      return AiAnalysisResult.fromJson(jsonResult);
    } catch (e, stackTrace) {
      AppLogger.error('Error analyzing application with AI', e, stackTrace);
      throw Exception('Failed to analyze application: ${e.toString()}');
    }
  }
}
