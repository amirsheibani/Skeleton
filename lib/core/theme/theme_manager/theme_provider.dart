import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/core/theme/theme_manager/theme_notifier.dart';
import 'package:skeleton/core/theme/theme_manager/theme_state.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) => ThemeNotifier());
