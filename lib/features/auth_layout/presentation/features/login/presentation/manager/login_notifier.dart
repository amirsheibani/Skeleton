import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skeleton/core/di/base/di_setup.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/manager/login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  late final AuthService _authService;

  LoginNotifier() : super(const LoginInit()) {
    _authService = getIt<AuthService>();
  }

  /// ورود با ایمیل و رمز عبور
  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const LoginLoading();
    try {
      await _authService.signIn(email: email, password: password);
      state = const LoginSuccess();
    } on AuthException catch (e) {
      state = LoginFailed(e.message);
    } catch (e) {
      state = LoginFailed('خطا در ورود: ${e.toString()}');
    }
  }

  /// ورود با Google
  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const LoginLoading();
    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        state = const LoginSuccess();
      } else {
        state = const LoginFailed('خطا در ورود با Google');
      }
    } catch (e) {
      state = LoginFailed(e.toString());
    }
  }

  /// ورود با Facebook
  /// Sign in with Facebook
  Future<void> signInWithFacebook() async {
    state = const LoginLoading();
    try {
      final success = await _authService.signInWithFacebook();
      if (success) {
        state = const LoginSuccess();
      } else {
        state = const LoginFailed('خطا در ورود با Facebook');
      }
    } catch (e) {
      state = LoginFailed(e.toString());
    }
  }

  /// Reset state
  void reset() {
    state = const LoginInit();
  }
}

