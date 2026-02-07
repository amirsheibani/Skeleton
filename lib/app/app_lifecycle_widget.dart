import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton/core/di/base/mode_detection.dart';

class AppLifecycleWidget extends ConsumerStatefulWidget {
  const AppLifecycleWidget({super.key, required this.child});

  final Widget child;
  @override
  ConsumerState<AppLifecycleWidget> createState() => _AppLifecycleWidgetState();
}

class _AppLifecycleWidgetState extends ConsumerState<AppLifecycleWidget> with WidgetsBindingObserver {
  late final ModeDetection brightnessDetection;

  static const String _keyAppWasInForeground = 'app_was_in_foreground';
  static const String _keyAppLastForegroundTime = 'app_last_foreground_time';

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    WidgetsBinding.instance.addObserver(this);

    // چک کردن اینکه آیا اپ kill شده یا نه
    _checkIfAppWasKilled();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        _closeApp();
        break;
      case AppLifecycleState.resumed:
        _foregroundApp();
        break;
      case AppLifecycleState.paused:
        _backgroundApp();
        break;
      case AppLifecycleState.inactive:
      // اپ در حالت inactive (مثلاً هنگام نمایش notification)
        break;
      case AppLifecycleState.hidden:
      // اپ مخفی شده (iOS 14+)
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  /// چک کردن اینکه آیا اپ kill شده یا نه
  Future<void> _checkIfAppWasKilled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wasInForeground = prefs.getBool(_keyAppWasInForeground) ?? false;

      if (wasInForeground) {
        // اپ kill شده است!
        final lastForegroundTime = prefs.getInt(_keyAppLastForegroundTime) ?? 0;
        final killTime = DateTime.fromMillisecondsSinceEpoch(lastForegroundTime);

        if (kDebugMode) {
          print('🔴🔴🔴 اپ توسط کاربر KILL شد!');
          print('⏰ زمان kill: ${killTime.toString()}');
        }

        // اینجا می‌توانید کارهای لازم را انجام دهید
        // مثلاً: لاگ کردن، ارسال به سرور، ذخیره وضعیت و غیره
        _onAppKilled(killTime);

        // پاک کردن flag
        await prefs.remove(_keyAppWasInForeground);
      }
    } catch (e) {
      if (kDebugMode) {
        print('خطا در چک کردن kill شدن اپ: $e');
      }
    }
  }

  /// وقتی اپ kill می‌شود (فراخوانی می‌شود در startup بعدی)
  void _onAppKilled(DateTime killTime) {
    // اینجا می‌توانید کارهای لازم را انجام دهید
    // مثلاً: لاگ کردن، ارسال به سرور، ذخیره وضعیت و غیره
    if (kDebugMode) {
      print('📝 انجام کارهای لازم بعد از kill شدن اپ...');
    }
  }

  /// وقتی اپ توسط کاربر بسته می‌شود (از طریق AppLifecycleState.detached)
  Future<void> _closeApp() async {
    if (kDebugMode) {
      print('🔴 اپ بسته شد توسط کاربر (detached)');
    }

    // پاک کردن flag چون اپ به صورت عادی بسته شده
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyAppWasInForeground);
      await prefs.remove(_keyAppLastForegroundTime);
    } catch (e) {
      if (kDebugMode) {
        print('خطا در پاک کردن flag: $e');
      }
    }

    // اینجا می‌توانید کارهای لازم را انجام دهید
    // مثلاً: ذخیره داده‌ها، بستن اتصالات، لاگ کردن و غیره
  }

  /// وقتی اپ به foreground برمی‌گردد
  Future<void> _foregroundApp() async {
    if (kDebugMode) {
      print('🟢 اپ به foreground برگشت');
    }

    // ذخیره کردن flag که نشان می‌دهد اپ در foreground است
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyAppWasInForeground, true);
      await prefs.setInt(_keyAppLastForegroundTime, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      if (kDebugMode) {
        print('خطا در ذخیره flag: $e');
      }
    }

    // اینجا می‌توانید کارهای لازم را انجام دهید
    // مثلاً: به‌روزرسانی داده‌ها، اتصال مجدد به سرور و غیره
  }

  /// وقتی اپ به بک‌گراند می‌رود
  Future<void> _backgroundApp() async {
    if (kDebugMode) {
      print('🟡 اپ به بک‌گراند رفت');
    }

    // flag را نگه می‌داریم چون ممکن است اپ به foreground برگردد
    // اگر kill شود، در startup بعدی متوجه می‌شویم
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyAppLastForegroundTime, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      if (kDebugMode) {
        print('خطا در به‌روزرسانی timestamp: $e');
      }
    }

    // اینجا می‌توانید کارهای لازم را انجام دهید
    // مثلاً: نمایش notification، ذخیره وضعیت و غیره
  }



  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


