import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/app/router.dart';
import 'package:skeleton/core/config/locale_configs.dart';
import 'package:skeleton/core/di/base/di_setup.dart';
import 'package:skeleton/core/di/base/mode_detection.dart';
import 'package:skeleton/core/di/local/device_info.dart';
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

class _AppState extends ConsumerState<App> {
  late final ModeDetection brightnessDetection;

  @override
  void initState() {
    brightnessDetection = getIt<ModeDetection>();
    super.initState();
  }

  @override
  void dispose() {
    brightnessDetection.close();
    super.dispose();
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
