import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/main_layout/presentation/features/car_slope_info/presentation/manager/car_slope_notifier.dart';
import 'package:skeleton/features/main_layout/presentation/features/car_slope_info/presentation/manager/car_slope_state.dart';

final carSlopeProvider = StateNotifierProvider<CarSlopeNotifier, CarSlopeState>((ref) => CarSlopeNotifier());