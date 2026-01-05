import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/splash/presentation/manager/splash_state.dart';

class SplashNotifier extends AsyncNotifier<SplashState> {
  SplashNotifier();

  @override
  Future<SplashState> build() async {
    return await startSplash();
  }
  Future<SplashState> startSplash() async {
    state = const AsyncValue.loading();
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      state = const AsyncValue.data(SplashSuccess());
      return const SplashSuccess();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return const SplashFailed();
    }
  }

  void setSuccess() {
    state = const AsyncValue.data(SplashSuccess());
  }

  void setFailed() {
    state = const AsyncValue.data(SplashFailed());
  }

  void setLoading() {
    state = const AsyncValue.loading();
  }

  void reset() {
    state = const AsyncValue.data(SplashInit());
  }
}
