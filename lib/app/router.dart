import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/pages/login_page.dart';
import 'package:skeleton/features/auth_layout/presentation/features/register/presentation/pages/register_page.dart';
import 'package:skeleton/features/auth_layout/presentation/layout/auth_layout.dart';
import 'package:skeleton/features/main_layout/presentation/features/home/presentation/pages/home_page.dart';
import 'package:skeleton/features/main_layout/presentation/features/profile/presentation/pages/profile_page.dart';
import 'package:skeleton/features/main_layout/presentation/pages/main_layout.dart';
import 'package:skeleton/features/splash/presentation/pages/splash_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((event) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  // refreshListenable: GoRouterRefreshStream(),
  redirect: (context,state){
    final loggedIn = true;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');
    final isSplash = state.matchedLocation == '/splash';

    if (isSplash) return null;
    if (!loggedIn && !isAuthRoute) return '/auth/login';
    if (loggedIn && isAuthRoute) return '/';

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashPage(),
    ),

    ShellRoute(
      builder: (context, state, child) => AuthLayout(child: child),
      routes: [
        GoRoute(
          path: '/auth/login',
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          path: '/auth/register',
          builder: (_, __) => const RegisterPage(),
        ),
      ],
    ),

    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const HomePage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (_, __) => const ProfilePage(),
        ),
      ],
    ),
  ],
);