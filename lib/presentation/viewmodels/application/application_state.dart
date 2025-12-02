import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:job_connect/data/models/application_model.dart';

part 'application_state.freezed.dart';

/// Application form state
@freezed
class ApplicationFormState with _$ApplicationFormState {
  const factory ApplicationFormState({
    String? resumeFilePath,
    String? resumeFileName,
    Uint8List? resumeBytes, // For web platform
    @Default('') String coverLetter,
    @Default(false) bool isLoading,
    String? resumeError,
    String? coverLetterError,
    String? generalError,
  }) = _ApplicationFormState;
}

/// Application submission state
@freezed
class ApplicationSubmitState with _$ApplicationSubmitState {
  const factory ApplicationSubmitState.initial() = _Initial;
  const factory ApplicationSubmitState.loading() = _Loading;
  const factory ApplicationSubmitState.success(ApplicationModel application) =
      _Success;
  const factory ApplicationSubmitState.error(String message) = _Error;
}
