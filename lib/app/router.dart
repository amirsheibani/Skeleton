import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:skeleton/features/auth_layout/presentation/features/login/presentation/pages/login_page.dart';
import 'package:skeleton/features/auth_layout/presentation/features/register/presentation/pages/register_page.dart';
import 'package:skeleton/features/auth_layout/presentation/layout/auth_layout.dart';
import 'package:skeleton/features/main_layout/presentation/features/gps_info/presentation/pages/gps_info_page.dart';
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

final appRouterName  = {

};

enum AppRouterPath{
  splash('/splash'),
  login('/auth/login'),
  register('/auth/register'),

  home('/'),
  profile('/profile'),
  gpsInfo('/gps-info'),
  ;



  final String path;
  const AppRouterPath(this.path);
}

final appRouter = GoRouter(
  initialLocation: AppRouterPath.splash.path,
  refreshListenable: GoRouterRefreshStream(AppLinks().uriLinkStream),
  redirect: (context,state){
    // final loggedIn = true;
    // final isAuthRoute = state.matchedLocation.startsWith('/auth');
    // final isSplash = state.matchedLocation == '/splash';
    //
    // if (isSplash) return null;
    // if (!loggedIn && !isAuthRoute) return '/auth/login';
    // if (loggedIn && isAuthRoute) return '/';

    if(state.uri.scheme == 'myapp' && state.uri.host =='profile'){
      return AppRouterPath.profile.path;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRouterPath.splash.path,
      builder: (_, __) => const SplashPage(),
    ),

    ShellRoute(
      builder: (context, state, child) => AuthLayout(child: child),
      routes: [
        GoRoute(
          path: AppRouterPath.login.path,
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          path: AppRouterPath.register.path,
          builder: (_, __) => const RegisterPage(),
        ),
      ],
    ),

    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: AppRouterPath.home.path,
          builder: (_, __) => const HomePage(),
        ),
        GoRoute(
          path: AppRouterPath.profile.path,
          builder: (_, __) => const ProfilePage(),
        ),
        GoRoute(
          path: AppRouterPath.gpsInfo.path,
          builder: (_, __) => const GPSInfoPage(),
        ),
      ],
    ),
  ],
);