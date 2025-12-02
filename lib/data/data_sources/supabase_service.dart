import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:job_connect/config/env_config.dart';
import 'package:job_connect/core/utils/logger.dart';

/// Supabase client singleton
class SupabaseService {
  SupabaseService._();

  static SupabaseClient? _client;

  /// Get Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase has not been initialized. Call init() first.');
    }
    return _client!;
  }

  /// Initialize Supabase
  static Future<void> init() async {
    try {
      await Supabase.initialize(
        url: EnvConfig.supabaseUrl,
        anonKey: EnvConfig.supabaseAnonKey,
      );
      _client = Supabase.instance.client;
      AppLogger.info('Supabase initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Supabase', e, stackTrace);
      rethrow;
    }
  }

  /// Get current user
  static User? get currentUser => _client?.auth.currentUser;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  /// Get auth state stream
  static Stream<AuthState> get authStateChanges {
    return _client!.auth.onAuthStateChange;
  }
}
