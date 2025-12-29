import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/core/theme/app_theme.dart';
import 'package:skeleton/core/theme/theme_manager/theme_state.dart';

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState(ThemeType.system));

  void setLight() => state = const ThemeState(ThemeType.light);
  void setDark() => state = const ThemeState(ThemeType.dark);
  void setSystem() => state = const ThemeState(ThemeType.system);
}
