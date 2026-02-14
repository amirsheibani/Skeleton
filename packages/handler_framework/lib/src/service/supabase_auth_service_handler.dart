/// سرویس مدیریت احراز هویت با Supabase
/// Authentication management service with Supabase
///
/// این سرویس عملیات مربوط به ثبت‌نام، ورود، خروج و مدیریت جلسه کاربر را
/// با استفاده از Supabase انجام می‌دهد.
///
/// This service handles user registration, login, logout, and session management
/// using Supabase.
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class AuthServiceModule {
  @lazySingleton
  AuthService provideAuthService() => AuthService();
}

class AuthService {
  final SupabaseClient _supabase;

  AuthService() : _supabase = Supabase.instance.client {
    // Initialize Supabase if not already initialized
    // This should be done in bootstrap.dart
  }

  /// دریافت کاربر فعلی
  /// Get current user
  User? get currentUser => _supabase.auth.currentUser;

  /// بررسی اینکه آیا کاربر وارد شده است
  /// Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  /// استریم وضعیت احراز هویت
  /// Stream of authentication state
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// ثبت‌نام با ایمیل و رمز عبور
  /// Sign up with email and password
  ///
  /// [email]: ایمیل کاربر / User email
  /// [password]: رمز عبور / Password
  /// [fullName]: نام کامل کاربر / User full name
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      if (kDebugMode) {
        print('✅ ثبت‌نام موفق: ${response.user?.email}');
        // Sign up successful
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطا در ثبت‌نام: $e');
        // Error in sign up
      }
      rethrow;
    }
  }

  /// ورود با ایمیل و رمز عبور
  /// Sign in with email and password
  ///
  /// [email]: ایمیل کاربر / User email
  /// [password]: رمز عبور / Password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print('✅ ورود موفق: ${response.user?.email}');
        // Sign in successful
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطا در ورود: $e');
        // Error in sign in
      }
      rethrow;
    }
  }

  /// خروج از حساب کاربری
  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      if (kDebugMode) {
        print('✅ خروج موفق');
        // Sign out successful
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطا در خروج: $e');
        // Error in sign out
      }
      rethrow;
    }
  }

  /// ارسال لینک بازیابی رمز عبور
  /// Send password reset link
  ///
  /// [email]: ایمیل کاربر / User email
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      if (kDebugMode) {
        print('✅ لینک بازیابی رمز عبور ارسال شد به: $email');
        // Password reset link sent
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطا در ارسال لینک بازیابی: $e');
        // Error sending reset link
      }
      rethrow;
    }
  }

  /// ورود با Google
  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطا در ورود با Google: $e');
        // Error in Google sign in
      }
      return false;
    }
  }

  /// ورود با Facebook
  /// Sign in with Facebook
  Future<bool> signInWithFacebook() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطا در ورود با Facebook: $e');
        // Error in Facebook sign in
      }
      return false;
    }
  }

  /// به‌روزرسانی اطلاعات کاربر
  /// Update user information
  Future<UserResponse> updateUser({
    String? email,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          email: email,
          password: password,
          data: data,
        ),
      );

      if (kDebugMode) {
        print('✅ اطلاعات کاربر به‌روزرسانی شد');
        // User information updated
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطا در به‌روزرسانی اطلاعات: $e');
        // Error updating user information
      }
      rethrow;
    }
  }
}

