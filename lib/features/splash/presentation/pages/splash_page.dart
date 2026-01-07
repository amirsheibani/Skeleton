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
                context.go(AppRouterPath.login.path);
              },
            );
          },
          fireImmediately: true,
        );

        // طراحی صفحه اسپلش مطابق دیزاین ارسال‌شده
        return const _SplashView();
      },
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // گرادینت‌های نرم گوشه‌ها
          Positioned(
            top: -120,
            right: -80,
            child: _SoftCircle(
              colors: [
                primary.withOpacity(0.18),
                Colors.white,
              ],
              size: 260,
            ),
          ),
          Positioned(
            bottom: -140,
            left: -100,
            child: _SoftCircle(
              colors: [
                primary.withOpacity(0.14),
                Colors.white,
              ],
              size: 320,
            ),
          ),
          Positioned(
            bottom: -120,
            right: -40,
            child: _SoftCircle(
              colors: [
                primary.withOpacity(0.12),
                Colors.white,
              ],
              size: 220,
            ),
          ),

          // لوگوی مرکزی
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LogoMark(color: primary),
                const SizedBox(height: 16),
                Text(
                  'evenzo',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({
    required this.colors,
    required this.size,
  });

  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: colors,
          center: const Alignment(-0.2, -0.2),
          radius: 0.9,
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.07),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          'e',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
