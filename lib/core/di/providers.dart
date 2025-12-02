import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_connect/data/repositories/auth_repository.dart';
import 'package:job_connect/data/repositories/job_repository.dart';
import 'package:job_connect/data/repositories/application_repository.dart';
import 'package:job_connect/data/repositories/ai_rating_repository.dart';
import 'package:job_connect/data/repositories/profile_repository.dart';

part 'providers.g.dart';

/// Auth repository provider
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository();
}

/// Job repository provider
@riverpod
JobRepository jobRepository(JobRepositoryRef ref) {
  return JobRepository();
}

/// Application repository provider
@riverpod
ApplicationRepository applicationRepository(ApplicationRepositoryRef ref) {
  return ApplicationRepository();
}

/// AI rating repository provider
@riverpod
AiRatingRepository aiRatingRepository(AiRatingRepositoryRef ref) {
  return AiRatingRepository();
}

/// Profile repository provider
@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository();
}
