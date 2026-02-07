import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/main_layout/presentation/manager/main_layout_notifier.dart';

final mainLayoutProvider = StateNotifierProvider<MainLayoutNotifier, int>((ref) => MainLayoutNotifier());