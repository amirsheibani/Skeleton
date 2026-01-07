import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeleton/app/router.dart';
import 'package:skeleton/core/handler/service/kiosk_exit_dialog.dart';
import 'package:skeleton/core/handler/service/kiosk_service.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/features/splash/presentation/manager/splash_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _tapCount = 0;
  @override
  void initState() {
    super.initState();
    KioskService.start();
  }

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () {
        _tapCount++;
        if (_tapCount >= 5) {
          _tapCount = 0;
          showKioskExit(context);
        }
      },
      child: Consumer(
        builder: (context, ref, child) {
          ref.listenManual(
              splashProvider,
                  (pre, next) {
                next.whenOrNull(
                  data: (value) {
                    // context.go(AppRouterPath.carSlope.path);
                    // context.go(AppRouterPath.login.path);
                  },
                );
              },
              fireImmediately: true);
          return ref
              .watch(splashProvider)
              .whenOrNull(
            loading: () {
              return Placeholder(child: Center(child: CircularProgressIndicator()));
            },
          ) ??
              Placeholder(
                child: Center(
                  child: Text('SplashPage', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primary)),
                ),
              );
        },
      ),
    );




  }
}
