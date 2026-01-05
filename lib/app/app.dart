
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton/app/router.dart';
import 'package:skeleton/core/config/locale_configs.dart';
import 'package:skeleton/core/di/base/di_setup.dart';
import 'package:skeleton/core/di/base/mode_detection.dart';
import 'package:skeleton/core/di/local/device_info.dart';
import 'package:skeleton/core/handler/service/internet_service_handler.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/core/theme/theme_manager/theme_provider.dart';
import 'package:skeleton/core/widgets/app_blur_overlay.dart';
import 'package:skeleton/core/widgets/dismissible_keyboard.dart';
import 'package:skeleton/generated/l10n.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  late final ModeDetection brightnessDetection;

  late final InternetService _internetService;

  // late final NFCService _nfcService;

  static const String _keyAppWasInForeground = 'app_was_in_foreground';
  static const String _keyAppLastForegroundTime = 'app_last_foreground_time';

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    WidgetsBinding.instance.addObserver(this);
    brightnessDetection = getIt<ModeDetection>();
    _internetService = getIt<InternetService>();
    
    // چک کردن اینکه آیا اپ kill شده یا نه
    _checkIfAppWasKilled();
    // _nfcService = getIt<NFCService>();
    // _nfcService.internetStatus.listen((status) async {
    //   NfcAvailability nfcAvailability = status.$1;
    //   if(nfcAvailability == NfcAvailability.enabled){
    //     NfcTag nfcTag = status.$2;
    //     final Ndef? ndef = Ndef.from(nfcTag);
    //
    //     StringBuffer stringBuffer = StringBuffer();
    //     ndef?.cachedMessage?.records.forEach((record){
    //       stringBuffer.write( utf8.decode(record.payload));
    //     });
    //     print('message');
    //     print(stringBuffer.toString());
    //   }
    // });
    _internetService.internetStatus.listen((status) {
      ConnectivityResult connectivityResult = status.$2;
      bool internetStatus = status.$1;
      switch (connectivityResult) {
        case ConnectivityResult.bluetooth:
          print('Bluetooth & ${internetStatus ? 'has' : 'has not'} internet');
          break;
        case ConnectivityResult.wifi:
          print('WiFi & ${internetStatus ? 'has' : 'has not'} internet');
          break;
        case ConnectivityResult.ethernet:
          print('Ethernet & ${internetStatus ? 'has' : 'has not'} internet');
          break;
        case ConnectivityResult.mobile:
          print('Mobile Data & ${internetStatus ? 'has' : 'has not'} internet');
          break;
        case ConnectivityResult.none:
          print('No Network');
          break;
        case ConnectivityResult.vpn:
          print('VPN connection Detected & ${internetStatus ? 'has' : 'has not'} internet');
          break;
        case ConnectivityResult.other:
          print('Network other & ${internetStatus ? 'has' : 'has not'} internet');
          break;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    brightnessDetection.close();
    _internetService.dispose();
    // _nfcService.dispose();
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
    final themeState = ref.watch(themeProvider);
    final ThemeData theme = switch (themeState.type) {
      ThemeType.light => ThemeData.light(),
      ThemeType.dark => ThemeData.dark(),
      ThemeType.system => ThemeData(brightness: MediaQuery.platformBrightnessOf(context)),
    };

    return StreamBuilder<String>(
      stream: brightnessDetection.getStream(),
      builder: (context, snapshot) {
        final deviceInfo = getIt<DeviceInfo>();
        if (deviceInfo.platformName == PlatformName.iOS) {
          if (snapshot.hasData) {
            // context.read<ThemeAndLanguageCubit>().changeTheme(
            //     manualSelectThemeType: snapshot.data == 'dark'
            //         ? ThemeType.dark
            //         : ThemeType.light);
          }
        } else {
          PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
            // Brightness brightness = PlatformDispatcher.instance.platformBrightness;
            // context.read<ThemeAndLanguageCubit>().changeTheme(
            //     manualSelectThemeType: brightness == Brightness.dark
            //         ? ThemeType.dark
            //         : ThemeType.light);
          };
        }
        return DismissibleKeyboard(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: LocaleConfigs.localizationsDelegates,
            routerConfig: appRouter,
            theme: theme,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: DefaultTextStyle(
                  style: const TextStyle(fontFamily: 'IRANSansX'),
                  child: AppBlurOverlay(child: child ?? const SizedBox()),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _DesktopNotSupported extends StatelessWidget {
  const _DesktopNotSupported();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.redAccent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'این اپ فقط روی گوشی‌های موبایل قابل استفاده است.\nلطفاً از دستگاه موبایل استفاده کنید.',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
