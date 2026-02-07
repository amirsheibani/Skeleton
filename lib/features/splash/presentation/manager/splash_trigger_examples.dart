/// مثال‌های مختلف برای Trigger کردن Splash Provider
/// 
/// این فایل شامل مثال‌های مختلف برای trigger کردن splash provider است.
/// می‌توانید این کدها را در widget یا service خودتان استفاده کنید.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/splash/presentation/manager/splash_provider.dart';

// ============================================================================
// مثال 1: Trigger کردن از طریق refresh (ساده‌ترین روش)
// ============================================================================

/// این روش provider را refresh می‌کند و build() را دوباره اجرا می‌کند
void example1_refreshProvider(WidgetRef ref) {
  // این کار build() را دوباره اجرا می‌کند
  ref.refresh(splashProvider);
}

// ============================================================================
// مثال 2: Trigger کردن از طریق rebuild
// ============================================================================

/// این روش هم build() را دوباره اجرا می‌کند
Future<void> example2_rebuildProvider(WidgetRef ref) async {
  // این کار build() را دوباره اجرا می‌کند
  await ref.read(splashProvider.notifier).build();
}

// ============================================================================
// مثال 3: استفاده در initState یک StatefulWidget
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyWidget extends ConsumerStatefulWidget {
  const MyWidget({super.key});

  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Trigger کردن splash provider بعد از build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(splashProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Trigger کردن با دکمه
            ref.refresh(splashProvider);
          },
          child: const Text('Trigger Splash'),
        ),
      ),
    );
  }
}
*/

// ============================================================================
// مثال 4: استفاده در ConsumerWidget
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Trigger کردن splash provider
            ref.refresh(splashProvider);
          },
          child: const Text('Trigger Splash'),
        ),
      ),
    );
  }
}
*/

// ============================================================================
// مثال 5: Trigger کردن در splash_page خودش
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Trigger کردن splash provider وقتی صفحه build می‌شود
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(splashProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final splashState = ref.watch(splashProvider);
    
    return splashState.when(
      data: (data) => const Text('Success'),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
*/

// ============================================================================
// مثال 6: Trigger کردن با یک متد custom در Notifier
// ============================================================================

/*
// در main_layout_notifier.dart:
class SplashNotifier extends AsyncNotifier<SplashState> {
  @override
  Future<SplashState> build() async {
    // منطق اولیه
    return const SplashInit();
  }

  // متد custom برای trigger کردن
  Future<void> startSplash() async {
    state = const AsyncValue.loading();
    try {
      // انجام کارهای لازم
      await Future.delayed(const Duration(seconds: 2));
      state = const AsyncValue.data(SplashSuccess());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // متد دیگر برای تغییر state
  void setSuccess() {
    state = const AsyncValue.data(SplashSuccess());
  }

  void setFailed() {
    state = const AsyncValue.data(SplashFailed());
  }
}

// استفاده:
void example6_customMethod(WidgetRef ref) {
  // استفاده از متد custom
  ref.read(splashProvider.notifier).startSplash();
  
  // یا
  ref.read(splashProvider.notifier).setSuccess();
}
*/

// ============================================================================
// مثال 7: Trigger کردن از یک Service یا Repository
// ============================================================================

/*
class SplashService {
  final Ref ref;

  SplashService(this.ref);

  Future<void> initializeSplash() async {
    // انجام کارهای initialization
    await Future.delayed(const Duration(seconds: 1));
    
    // Trigger کردن splash provider
    ref.refresh(splashProvider);
  }
}

// استفاده:
void example7_fromService(WidgetRef ref) {
  final service = SplashService(ref);
  service.initializeSplash();
}
*/

// ============================================================================
// مثال 8: Trigger کردن با Future.microtask
// ============================================================================

void example8_withMicrotask(WidgetRef ref) {
  // استفاده از microtask برای trigger کردن بعد از build
  Future.microtask(() {
    ref.refresh(splashProvider);
  });
}

// ============================================================================
// مثال 9: Trigger کردن با Timer
// ============================================================================

/*
import 'dart:async';

void example9_withTimer(WidgetRef ref) {
  // Trigger کردن بعد از 1 ثانیه
  Timer(const Duration(seconds: 1), () {
    ref.refresh(splashProvider);
  });
}
*/

// ============================================================================
// مثال 10: Trigger کردن در bootstrap یا app initialization
// ============================================================================

/*
// در bootstrap.dart یا main.dart:
Future<void> appConfiguration() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ... سایر تنظیمات
  
  // Trigger کردن splash provider
  // (نیاز به Ref دارد - می‌توانید از ProviderContainer استفاده کنید)
}
*/


