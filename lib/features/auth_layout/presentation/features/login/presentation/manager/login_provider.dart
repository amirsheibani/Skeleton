import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/manager/login_notifier.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/manager/login_state.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

