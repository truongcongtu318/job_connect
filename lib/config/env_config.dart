import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:job_connect/core/utils/logger.dart';

/// Environment configuration class
class EnvConfig {
  // Supabase configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Gemini AI configuration
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  /// Initialize and load environment variables
  static Future<void> init() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // If .env file doesn't exist, continue with empty values
      // This allows the app to run without .env file (for testing)
      AppLogger.warning(
        'Warning: .env file not found. Using default/empty values.',
      );
    }
  }

  /// Validate that all required environment variables are set
  static bool validate() {
    if (supabaseUrl.isEmpty) {
      AppLogger.error('Error: SUPABASE_URL is not set in .env file');
      return false;
    }
    if (supabaseAnonKey.isEmpty) {
      AppLogger.error('Error: SUPABASE_ANON_KEY is not set in .env file');
      return false;
    }
    if (geminiApiKey.isEmpty) {
      AppLogger.error('Error: GEMINI_API_KEY is not set in .env file');
      return false;
    }
    return true;
  }
}
