import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/presentation/viewmodels/recruiter/ai_rating_state.dart';

part 'ai_rating_viewmodel.g.dart';

@riverpod
class AiRatingViewModel extends _$AiRatingViewModel {
  @override
  AiRatingState build(String applicationId) {
    loadRating();
    return const AiRatingState.initial();
  }

  /// Load existing rating
  Future<void> loadRating() async {
    state = const AiRatingState.loading();

    try {
      final repo = ref.read(aiRatingRepositoryProvider);
      final result = await repo.getRatingByApplication(applicationId);

      result.fold((error) => state = AiRatingState.error(error), (rating) {
        if (rating != null) {
          state = AiRatingState.loaded(rating);
        } else {
          state = const AiRatingState.notAnalyzed();
        }
      });
    } catch (e, stackTrace) {
      AppLogger.error('Error loading AI rating', e, stackTrace);
      state = const AiRatingState.error('Không thể tải đánh giá AI');
    }
  }

  /// Analyze application
  Future<void> analyzeApplication({
    required String resumeUrl,
    required String jobTitle,
    required String jobDescription,
    required String jobRequirements,
  }) async {
    state = const AiRatingState.loading();

    try {
      final repo = ref.read(aiRatingRepositoryProvider);
      final result = await repo.analyzeApplication(
        applicationId: applicationId,
        resumeUrl: resumeUrl,
        jobTitle: jobTitle,
        jobDescription: jobDescription,
        jobRequirements: jobRequirements,
      );

      result.fold(
        (error) => state = AiRatingState.error(error),
        (rating) => state = AiRatingState.loaded(rating),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error analyzing application', e, stackTrace);
      state = const AiRatingState.error('Đã xảy ra lỗi khi phân tích');
    }
  }
}
