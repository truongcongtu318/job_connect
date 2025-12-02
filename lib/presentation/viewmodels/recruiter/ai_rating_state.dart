import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:job_connect/data/models/ai_rating_model.dart';

part 'ai_rating_state.freezed.dart';

@freezed
class AiRatingState with _$AiRatingState {
  const factory AiRatingState.initial() = _Initial;
  const factory AiRatingState.loading() = _Loading;
  const factory AiRatingState.loaded(AiRatingModel rating) = _Loaded;
  const factory AiRatingState.notAnalyzed() = _NotAnalyzed;
  const factory AiRatingState.error(String message) = _Error;
}
