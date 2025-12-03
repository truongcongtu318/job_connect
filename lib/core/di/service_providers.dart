import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/data/data_sources/supabase_service.dart';
import 'package:job_connect/data/services/ai_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'service_providers.g.dart';

/// Supabase client provider
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return SupabaseService.client;
}

/// AI service provider
@riverpod
AiService aiService(Ref ref) {
  return AiService();
}
