import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeleton/app/router.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/features/splash/presentation/manager/splash_provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (context, ref, child) {
        ref.listenManual(
            splashProvider,
                (pre, next) {
          next.whenOrNull(
            data: (value) {
              // context.go(AppRouterPath.gpsInfo.path);
              context.go(AppRouterPath.mainLayout.path);
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
    );
  }
}
