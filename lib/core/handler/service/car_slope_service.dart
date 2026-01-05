import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import 'gps_service_handler.dart';
import 'motion_service_handler.dart';

/// سرویس مخصوص استفاده روی ماشین برای تشخیص سربالایی / سرپایینی
/// Car-specific service for detecting uphill / downhill slopes
///
/// این سرویس داده‌های GPS (تغییر ارتفاع و فاصله) را با داده‌های سنسور
/// (شتاب‌سنج و ژیروسکوپ) ترکیب می‌کند تا شیب جاده را با دقت مناسب برای خودرو
/// تخمین بزند.
///
/// This service combines GPS data (altitude change and distance) with sensor data
/// (accelerometer and gyroscope) to estimate road slope with appropriate accuracy for vehicles.

@module
abstract class CarSlopeServiceModule {
  @singleton
  CarSlopeService provideCarSlopeService(
    GPSService gpsService,
    MotionService motionService,
  ) =>
      CarSlopeService(
        gpsService: gpsService,
        motionService: motionService,
      );
}

/// جهت شیب برای خودرو
/// Car slope direction
enum CarSlopeDirection {
  uphill, // سربالایی / Uphill
  downhill, // سرپایینی / Downhill
  flat, // تقریبا صاف / Approximately flat
  unknown, // نامشخص / داده کافی نیست / Unknown / Insufficient data
}

/// داده‌ی نهایی شیب برای خودرو
/// Final car slope data
class CarSlopeData {
  final Position? position; // آخرین موقعیت GPS / Latest GPS position
  final double? gpsGrade; // شیب بر اساس GPS (Δh / d) / Slope based on GPS (Δh / d)
  final double? imuPitchDegrees; // pitch بر اساس سنسور (درجه) / Pitch based on sensor (degrees)
  final double fusedGrade; // شیب نهایی ترکیبی (تقریباً درصد شیب: 0.05 یعنی 5%) / Fused slope (approximately percentage: 0.05 means 5%)
  final CarSlopeDirection direction; // جهت نهایی / Final direction
  final double speedKmh; // سرعت تقریبی خودرو / Approximate vehicle speed
  final DateTime timestamp;

  const CarSlopeData({
    required this.position,
    required this.gpsGrade,
    required this.imuPitchDegrees,
    required this.fusedGrade,
    required this.direction,
    required this.speedKmh,
    required this.timestamp,
  });
}

class CarSlopeService {
  final GPSService _gpsService;
  final MotionService _motionService;

  CarSlopeService({
    required GPSService gpsService,
    required MotionService motionService,
  })  : _gpsService = gpsService,
        _motionService = motionService {
    _start();
  }

  // تنظیمات / Configuration
  static const double _minSpeedKmh = 10.0; // حداقل سرعت برای اعتماد به شیب / Minimum speed to trust slope
  static const double _minDistanceMeters = 20.0; // حداقل فاصله بین نقاط GPS / Minimum distance between GPS points
  static const double _gradeThreshold = 0.03; // ~۳٪ شیب / ~3% slope

  // وزن‌ها برای ترکیب GPS و IMU / Weights for combining GPS and IMU
  static const double _gpsWeight = 0.7;
  static const double _imuWeight = 0.3;

  final _slopeController = StreamController<CarSlopeData>.broadcast();

  /// استریم داده‌های شیب خودرو
  /// Stream of car slope data
  Stream<CarSlopeData> get slopeStream => _slopeController.stream;

  StreamSubscription<Position>? _gpsSub;
  StreamSubscription<MotionData>? _motionSub;

  MotionData? _lastMotion;
  Position? _lastGpsForGrade;

  double _lastFusedGrade = 0.0;
  CarSlopeDirection _lastDirection = CarSlopeDirection.unknown;

  CarSlopeDirection get lastDirection => _lastDirection;
  double get lastFusedGrade => _lastFusedGrade;

  void _start() {
    // گوش دادن به سنسور حرکت (IMU) / Listening to motion sensor (IMU)
    _motionSub = _motionService.motionStream.listen(
      (motion) {
        _lastMotion = motion;
      },
      onError: (e, s) {
        if (kDebugMode) {
          print('خطا در MotionService داخل CarSlopeService: $e');
          // Error in MotionService inside CarSlopeService
        }
      },
    );

    // گوش دادن به GPS / Listening to GPS
    _gpsSub = _gpsService.positionStream.listen(
      (position) {
        _processGps(position);
      },
      onError: (e, s) {
        if (kDebugMode) {
          print('خطا در GPS داخل CarSlopeService: $e');
          // Error in GPS inside CarSlopeService
        }
      },
    );
  }

  void _processGps(Position current) {
    final speedKmh = (current.speed.isNaN ? 0.0 : current.speed) * 3.6;

    // اگر سرعت خیلی کم است، به نتیجه اعتماد نکن
    // If speed is too low, don't trust the result
    if (speedKmh < _minSpeedKmh) {
      final data = CarSlopeData(
        position: current,
        gpsGrade: null,
        imuPitchDegrees: _lastMotion?.pitchDegrees,
        fusedGrade: 0.0,
        direction: CarSlopeDirection.unknown,
        speedKmh: speedKmh,
        timestamp: DateTime.now(),
      );
      _slopeController.add(data);
      return;
    }

    double? gpsGrade;

    if (_lastGpsForGrade != null) {
      final prev = _lastGpsForGrade!;

      final distance = _gpsService.calculateDistance(
        prev.latitude,
        prev.longitude,
        current.latitude,
        current.longitude,
      );

      if (distance >= _minDistanceMeters &&
          prev.altitude != 0 &&
          current.altitude != 0) {
        final deltaH = current.altitude - prev.altitude; // متر / meters
        gpsGrade = distance == 0
            ? null
            : (deltaH / distance); // تقریباً tan(theta) ~ درصد شیب / Approximately tan(theta) ~ slope percentage
      }
    }

    // به‌روزرسانی نقطه‌ی مرجع / Update reference point
    _lastGpsForGrade = current;

    // محاسبه grade از روی pitch (IMU) اگر موجود باشد
    // Calculate grade from pitch (IMU) if available
    double? imuGrade;
    final imuPitch = _lastMotion?.pitchDegrees;
    if (imuPitch != null) {
      final rad = imuPitch * math.pi / 180.0;
      imuGrade = math.tan(rad); // برای زاویه‌های کوچک، تقریباً درصد شیب / For small angles, approximately slope percentage
    }

    // ترکیب GPS و IMU / Combine GPS and IMU
    double fusedGrade;
    if (gpsGrade != null && imuGrade != null) {
      fusedGrade = _gpsWeight * gpsGrade + _imuWeight * imuGrade;
    } else if (gpsGrade != null) {
      fusedGrade = gpsGrade;
    } else if (imuGrade != null) {
      fusedGrade = imuGrade;
    } else {
      fusedGrade = 0.0;
    }

    _lastFusedGrade = fusedGrade;

    final direction = _detectDirectionFromGrade(fusedGrade);
    _lastDirection = direction;

    final data = CarSlopeData(
      position: current,
      gpsGrade: gpsGrade,
      imuPitchDegrees: imuPitch,
      fusedGrade: fusedGrade,
      direction: direction,
      speedKmh: speedKmh,
      timestamp: DateTime.now(),
    );

    _slopeController.add(data);

    if (kDebugMode) {
      final gradePercent = (fusedGrade * 100).toStringAsFixed(1);
      print(
        'CarSlope | dir=$direction, fusedGrade=$gradePercent٪, '
        'gpsGrade=${gpsGrade != null ? (gpsGrade * 100).toStringAsFixed(1) : 'null'}٪, '
        'imuPitch=${imuPitch?.toStringAsFixed(1)}, speed=${speedKmh.toStringAsFixed(1)} km/h',
      );
    }
  }

  CarSlopeDirection _detectDirectionFromGrade(double grade) {
    if (grade.abs() < _gradeThreshold) {
      return CarSlopeDirection.flat;
    }

    if (grade > 0) {
      return CarSlopeDirection.uphill;
    }

    if (grade < 0) {
      return CarSlopeDirection.downhill;
    }

    return CarSlopeDirection.unknown;
  }

  /// آزاد کردن منابع
  /// Dispose resources
  Future<void> dispose() async {
    await _gpsSub?.cancel();
    await _motionSub?.cancel();
    await _slopeController.close();

    if (kDebugMode) {
      print('CarSlopeService disposed');
    }
  }
}


