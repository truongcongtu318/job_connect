import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_connect/core/di/providers.dart';
import 'package:job_connect/core/utils/extensions.dart';
import 'package:job_connect/core/utils/logger.dart';
import 'package:job_connect/presentation/viewmodels/auth/auth_state.dart';

part 'auth_viewmodel.g.dart';

/// Authentication ViewModel
@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthState build() {
    // Check if user is already authenticated
    _checkAuthState();
    return const AuthState.initial();
  }

  Future<void> _checkAuthState() async {
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.getCurrentUser();

    result.fold((error) => state = const AuthState.unauthenticated(), (user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    state = const AuthState.loading();

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signIn(
      email: email.trim(),
      password: password,
    );

    result.fold(
      (error) {
        AppLogger.error('Sign in failed: $error');
        state = AuthState.error(error);
      },
      (user) {
        AppLogger.info('Sign in successful');
        state = AuthState.authenticated(user);
      },
    );
  }

  /// Sign up with user details
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
    String? companyName,
  }) async {
    state = const AuthState.loading();

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signUp(
      email: email.trim(),
      password: password,
      fullName: fullName.trim(),
      role: role,
      phone: phone?.trim(),
      companyName: companyName?.trim(),
    );

    result.fold(
      (error) {
        AppLogger.error('Sign up failed: $error');
        state = AuthState.error(error);
      },
      (user) {
        AppLogger.info('Sign up successful');
        state = AuthState.authenticated(user);
      },
    );
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AuthState.loading();

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.signOut();

    result.fold(
      (error) {
        AppLogger.error('Sign out failed: $error');
        state = AuthState.error(error);
      },
      (_) {
        AppLogger.info('Sign out successful');
        state = const AuthState.unauthenticated();
      },
    );
  }

  /// Clear error state
  void clearError() {
    state = const AuthState.unauthenticated();
  }
}

/// Login form ViewModel
@riverpod
class LoginFormViewModel extends _$LoginFormViewModel {
  @override
  LoginFormState build() {
    return const LoginFormState();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email, emailError: null, generalError: null);
  }

  void setPassword(String password) {
    state = state.copyWith(
      password: password,
      passwordError: null,
      generalError: null,
    );
  }

  bool _validateForm() {
    String? emailError;
    String? passwordError;

    if (state.email.isEmpty) {
      emailError = 'Email không được để trống';
    } else if (!state.email.isValidEmail) {
      emailError = 'Email không hợp lệ';
    }

    if (state.password.isEmpty) {
      passwordError = 'Mật khẩu không được để trống';
    } else if (state.password.length < 6) {
      passwordError = 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
    );

    return emailError == null && passwordError == null;
  }

  Future<bool> submit() async {
    if (!_validateForm()) {
      return false;
    }

    state = state.copyWith(isLoading: true, generalError: null);

    try {
      await ref
          .read(authViewModelProvider.notifier)
          .signIn(state.email, state.password);

      // Check if sign in was successful
      final authState = ref.read(authViewModelProvider);

      return authState.maybeWhen(
        authenticated: (_) {
          state = state.copyWith(isLoading: false);
          return true;
        },
        error: (message) {
          state = state.copyWith(isLoading: false, generalError: message);
          return false;
        },
        orElse: () {
          state = state.copyWith(isLoading: false);
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        generalError: 'Đã xảy ra lỗi không mong muốn',
      );
      return false;
    }
  }

  void reset() {
    state = const LoginFormState();
  }
}

/// Register form ViewModel
@riverpod
class RegisterFormViewModel extends _$RegisterFormViewModel {
  @override
  RegisterFormState build() {
    return const RegisterFormState();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email, emailError: null, generalError: null);
  }

  void setPassword(String password) {
    state = state.copyWith(
      password: password,
      passwordError: null,
      generalError: null,
    );
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(
      confirmPassword: confirmPassword,
      confirmPasswordError: null,
      generalError: null,
    );
  }

  void setFullName(String fullName) {
    state = state.copyWith(
      fullName: fullName,
      fullNameError: null,
      generalError: null,
    );
  }

  void setPhone(String phone) {
    state = state.copyWith(phone: phone, generalError: null);
  }

  void setCompanyName(String companyName) {
    state = state.copyWith(companyName: companyName, generalError: null);
  }

  void setRole(String role) {
    state = state.copyWith(
      selectedRole: role,
      roleError: null,
      generalError: null,
      // Clear company name if switching to candidate
      companyName: role == 'candidate' ? null : state.companyName,
    );
  }

  bool _validateForm() {
    String? emailError;
    String? passwordError;
    String? confirmPasswordError;
    String? fullNameError;
    String? roleError;

    if (state.email.isEmpty) {
      emailError = 'Email không được để trống';
    } else if (!state.email.isValidEmail) {
      emailError = 'Email không hợp lệ';
    }

    if (state.password.isEmpty) {
      passwordError = 'Mật khẩu không được để trống';
    } else if (state.password.length < 6) {
      passwordError = 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    if (state.confirmPassword.isEmpty) {
      confirmPasswordError = 'Vui lòng xác nhận mật khẩu';
    } else if (state.password != state.confirmPassword) {
      confirmPasswordError = 'Mật khẩu xác nhận không khớp';
    }

    if (state.fullName.isEmpty) {
      fullNameError = 'Họ và tên không được để trống';
    }

    if (state.selectedRole == null) {
      roleError = 'Vui lòng chọn vai trò';
    }

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      fullNameError: fullNameError,
      roleError: roleError,
    );

    return emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        fullNameError == null &&
        roleError == null;
  }

  Future<bool> submit() async {
    if (!_validateForm()) {
      return false;
    }

    state = state.copyWith(isLoading: true, generalError: null);

    try {
      await ref
          .read(authViewModelProvider.notifier)
          .signUp(
            email: state.email,
            password: state.password,
            fullName: state.fullName,
            role: state.selectedRole!,
            phone: state.phone,
            companyName: state.companyName,
          );

      // Check if sign up was successful
      final authState = ref.read(authViewModelProvider);

      return authState.maybeWhen(
        authenticated: (_) {
          state = state.copyWith(isLoading: false);
          return true;
        },
        error: (message) {
          state = state.copyWith(isLoading: false, generalError: message);
          return false;
        },
        orElse: () {
          state = state.copyWith(isLoading: false);
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        generalError: 'Đã xảy ra lỗi không mong muốn',
      );
      return false;
    }
  }

  void reset() {
    state = const RegisterFormState();
  }
}
