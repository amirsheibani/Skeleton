import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/splash/presentation/manager/splash_notifier.dart';
import 'package:skeleton/features/splash/presentation/manager/splash_state.dart';

final splashProvider = AsyncNotifierProvider<SplashNotifier, SplashState>(SplashNotifier.new);
