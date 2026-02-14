import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:skeleton/core/di/base/di_setup.dart';
import 'package:skeleton/features/auth_layout/presentation/features/register/presentation/manager/register_state.dart';

class RegisterNotifier extends StateNotifier<RegisterState> {
  late final AuthService _authService;

  RegisterNotifier() : super(const RegisterInit()) {
    _authService = getIt<AuthService>();
  }

  /// ثبت‌نام با ایمیل و رمز عبور
  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    state = const RegisterLoading();
    try {
      await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      state = const RegisterSuccess();
    } on AuthException catch (e) {
      state = RegisterFailed(e.message);
    } catch (e) {
      state = RegisterFailed('خطا در ثبت‌نام: ${e.toString()}');
    }
  }

  /// Reset state
  void reset() {
    state = const RegisterInit();
  }
}

