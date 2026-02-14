
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framework_base/packages/framework_core/lib/core_framework.dart';
import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';
import 'package:framework_base/packages/framework_utils/lib/utils_framework.dart';
import 'package:skeleton/app/app_lifecycle_widget.dart';
import 'package:skeleton/app/router.dart';
import 'package:skeleton/core/config/locale_configs.dart';
import 'package:skeleton/core/di/base/di_setup.dart';
import 'package:skeleton/core/di/base/mode_detection.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/generated/l10n.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final ModeDetection brightnessDetection;

  late final InternetService _internetService;


  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    brightnessDetection = getIt<ModeDetection>();
    _internetService = getIt<InternetService>();
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
    brightnessDetection.close();
    _internetService.dispose();
    // _nfcService.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final ThemeData baseTheme = switch (themeState.type) {
      ThemeType.light => ThemeData.light(),
      ThemeType.dark => ThemeData.dark(),
      ThemeType.system => ThemeData(brightness: MediaQuery.platformBrightnessOf(context)),
    };
    // اعمال تم سفارشی (پالت، bottom nav، و...) از app_theme
    final ThemeData theme = baseTheme.theme(null);

    return AppLifecycleWidget(
      child: StreamBuilder<String>(
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
                return child ?? SizedBox();



                  MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: DefaultTextStyle(
                    style: const TextStyle(fontFamily: 'IRANSansX'),
                    // child: AppBlurOverlay(child: child ?? const SizedBox()),
                    child: child ?? const SizedBox(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


