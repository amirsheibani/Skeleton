import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/main_layout/presentation/features/gps_info/presentation/manager/gps_notifier.dart';
import 'package:skeleton/features/main_layout/presentation/features/gps_info/presentation/manager/gps_state.dart';

final gpsProvider = StateNotifierProvider<GPSNotifier, GPSState>((ref) => GPSNotifier());