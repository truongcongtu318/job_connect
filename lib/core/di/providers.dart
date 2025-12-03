import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_connect/core/di/service_providers.dart';
import 'package:job_connect/data/repositories/ai_rating_repository.dart';
import 'package:job_connect/data/repositories/application_repository.dart';
import 'package:job_connect/data/repositories/auth_repository.dart';
import 'package:job_connect/data/repositories/company_repository.dart';
import 'package:job_connect/data/repositories/job_repository.dart';
import 'package:job_connect/data/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

/// Auth repository provider
@riverpod
AuthRepository authRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(client);
}

/// Job repository provider
@riverpod
JobRepository jobRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return JobRepository(client);
}

/// Application repository provider
@riverpod
ApplicationRepository applicationRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return ApplicationRepository(client);
}

/// AI rating repository provider
@riverpod
AiRatingRepository aiRatingRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  final aiService = ref.watch(aiServiceProvider);
  return AiRatingRepository(client, aiService);
}

/// Profile repository provider
@riverpod
ProfileRepository profileRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProfileRepository(client);
}

/// Company repository provider
@riverpod
CompanyRepository companyRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return CompanyRepository(client);
}
