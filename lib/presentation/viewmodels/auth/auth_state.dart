import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:job_connect/data/models/user_model.dart';

part 'auth_state.freezed.dart';

/// Authentication state
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserModel user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

/// Login form state
@freezed
class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isLoading,
    String? emailError,
    String? passwordError,
    String? generalError,
  }) = _LoginFormState;
}

/// Registration form state
@freezed
class RegisterFormState with _$RegisterFormState {
  const factory RegisterFormState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String fullName,
    String? phone,
    String? companyName,
    String? selectedRole, // 'candidate' or 'recruiter'
    @Default(false) bool isLoading,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? fullNameError,
    String? roleError,
    String? generalError,
  }) = _RegisterFormState;
}
