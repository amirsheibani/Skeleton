import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skeleton/core/di/base/di_setup.dart';
import 'package:skeleton/features/main_layout/presentation/features/car_slope_info/presentation/manager/car_slope_state.dart';

class CarSlopeNotifier extends StateNotifier<CarSlopeState> {
  // late CarSlopeService _carSlopeService;
  // late GPSService _gpsService;
  StreamSubscription<CarSlopeData>? _slopeSubscription;

  CarSlopeNotifier() : super(const CarSlopeInit()) {}

  /// Initialize and start listening to slope data
  /// مقداردهی اولیه و شروع listening به داده‌های شیب
  Future<void> init() async {
    state = const CarSlopeLoading();
    try {
      GPSService _gpsService = getIt<GPSService>();
      // ابتدا permission را چک و درخواست می‌کنیم
      final permissionStatus = await _gpsService.requestPermission();
      
      if (permissionStatus != GPSPermissionStatus.granted) {
        state = CarSlopeFailed('GPS permission داده نشده است. لطفاً permission را فعال کنید.');
        return;
      }

      // مهم: گرفتن یک موقعیت اولیه برای "warm-up" کردن GPS
      // این کار باعث می‌شود GPS فعال شود (مشکل رایج در Android)
      // Important: Get an initial position to "warm-up" GPS
      // This helps activate GPS (common issue on Android)
      state = const CarSlopeLoading();
      final initialPosition = await _gpsService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: 15,
      );

      if (initialPosition == null) {
        // اگر نتوانست موقعیت اولیه را بگیرد، سعی می‌کنیم با lastKnownPosition شروع کنیم
        // If couldn't get initial position, try with lastKnownPosition
        final lastPosition = await _gpsService.getLastKnownPosition();
        if (lastPosition == null) {
          state = CarSlopeFailed(
            'GPS فعال نیست یا نمی‌تواند موقعیت را دریافت کند.\n'
            'لطفاً GPS را فعال کنید و چند ثانیه صبر کنید.\n'
            'یا Google Maps را یک بار باز کنید تا GPS فعال شود.',
          );
          return;
        }
      }

      // شروع listening به GPS (مهم: باید قبل از listening به slope stream باشد)
      // Start listening to GPS (important: must be before listening to slope stream)
      final gpsListeningStarted = await _gpsService.startListening(
        desiredAccuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );

      if (!gpsListeningStarted) {
        state = CarSlopeFailed('نتوانست GPS listening را شروع کند');
        return;
      }

      // حالا listening به slope stream را شروع می‌کنیم
      // Now start listening to slope stream
      await startListening();
    } catch (e) {
      state = CarSlopeFailed('خطا در مقداردهی اولیه: $e');
    }
  }

  /// Start listening to slope stream
  /// شروع listening به stream شیب
  Future<void> startListening() async {
    try {
      _slopeSubscription?.cancel();
      CarSlopeService _carSlopeService = getIt<CarSlopeService>();
      _slopeSubscription = _carSlopeService.slopeStream.listen(
        (slopeData) {
          state = CarSlopeSuccess(
            slopeData: slopeData,
            isListening: true,
          );
        },
        onError: (error) {
          state = CarSlopeFailed('خطا در دریافت داده: $error');
        },
      );

      state = const CarSlopeSuccess(
        slopeData: null,
        isListening: true,
      );
    } catch (e) {
      state = CarSlopeFailed('خطا در شروع listening: $e');
    }
  }

  /// Stop listening to slope stream
  /// توقف listening به stream شیب
  Future<void> stopListening() async {
    try {
      await _slopeSubscription?.cancel();
      _slopeSubscription = null;
      GPSService _gpsService = getIt<GPSService>();
      // توقف GPS listening هم
      await _gpsService.stopListening();

      final currentState = state;
      if (currentState is CarSlopeSuccess) {
        state = CarSlopeSuccess(
          slopeData: currentState.slopeData,
          isListening: false,
        );
      } else {
        state = const CarSlopeSuccess(
          slopeData: null,
          isListening: false,
        );
      }
    } catch (e) {
      state = CarSlopeFailed('خطا در توقف listening: $e');
    }
  }

  @override
  void dispose() {
    _slopeSubscription?.cancel();
    super.dispose();
  }

  /// Reset state to initial
  /// بازگشت به حالت اولیه
  void reset() {
    _slopeSubscription?.cancel();
    _slopeSubscription = null;
    state = const CarSlopeInit();
  }
}

