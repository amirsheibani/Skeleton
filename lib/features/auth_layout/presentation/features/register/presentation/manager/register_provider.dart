import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/auth_layout/presentation/features/register/presentation/manager/register_notifier.dart';
import 'package:skeleton/features/auth_layout/presentation/features/register/presentation/manager/register_state.dart';

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier();
});

