import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sensors_plus/sensors_plus.dart';


/// این سرویس با استفاده از شتاب‌سنج (Accelerometer) و ژیروسکوپ (Gyroscope)
/// سعی می‌کند جهت حرکت روی شیب را به صورت تقریبی تشخیص دهد
/// (سربالایی / سرپایینی / سطح صاف).
///
/// This service uses accelerometer and gyroscope sensors to approximately detect
/// the direction of movement on a slope (uphill / downhill / flat surface).

@module
abstract class MotionServiceModule {
  @lazySingleton
  MotionService provideMotionService() => MotionService();
}

/// وضعیت تقریبی شیب حرکت
/// Approximate slope direction status
enum SlopeDirection {
  uphill, // سربالایی / Uphill
  downhill, // سرپایینی / Downhill
  flat, // سطح نسبتاً صاف / Relatively flat surface
  unknown, // نامشخص / Unknown
}

/// داده‌های ترکیبی حسگرها در یک لحظه
/// Combined sensor data at a moment
class MotionData {
  final AccelerometerEvent accelerometer;
  final GyroscopeEvent? gyroscope;
  final double pitchDegrees; // زاویه خم شدن به جلو/عقب (درجه) / Forward/backward tilt angle (degrees)
  final SlopeDirection slopeDirection;
  final DateTime timestamp;

  const MotionData({
    required this.accelerometer,
    required this.gyroscope,
    required this.pitchDegrees,
    required this.slopeDirection,
    required this.timestamp,
  });
}

class MotionService {
  // تنظیمات فیلتر و آستانه‌ها / Filter settings and thresholds
  static const double _pitchUphillThreshold = 8; // درجه / degrees
  static const double _pitchDownhillThreshold = -8; // درجه / degrees
  static const double _pitchFlatThreshold = 4; // درجه (بازه اطراف صفر) / degrees (range around zero)

  StreamSubscription<AccelerometerEvent>? _accelerometerSub;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSub;

  final _motionController = StreamController<MotionData>.broadcast();

  /// استریم داده‌های پردازش شده حرکت
  /// Stream of processed motion data
  Stream<MotionData> get motionStream => _motionController.stream;

  AccelerometerEvent? _lastAccelerometer;
  GyroscopeEvent? _lastGyroscope;

  double _lastPitch = 0; // آخرین pitch محاسبه شده (درجه) / Last calculated pitch (degrees)
  SlopeDirection _lastSlope = SlopeDirection.unknown;

  SlopeDirection get lastSlopeDirection => _lastSlope;
  double get lastPitchDegrees => _lastPitch;

  bool _isListening = false;

  /// آیا در حال listening است
  /// Whether currently listening
  bool get isListening => _isListening;

  MotionService() {
    _start();
  }

  /// شروع listening به سنسورها
  /// Start listening to sensors
  void _start() {
    if (_isListening) return;

    // گوش دادن به شتاب‌سنج / Listening to accelerometer
    _accelerometerSub = accelerometerEventStream().listen(
      (event) {
        _lastAccelerometer = event;
        _processSensors();
      },
      onError: (e, s) {
        if (kDebugMode) {
          print('خطا در accelerometer: $e');
          // Error in accelerometer
        }
      },
    );

    // گوش دادن به ژیروسکوپ (اختیاری، فعلاً فقط برای آینده نگه می‌داریم)
    // Listening to gyroscope (optional, currently kept for future use)
    _gyroscopeSub = gyroscopeEventStream().listen(
      (event) {
        _lastGyroscope = event;
        // در صورت نیاز می‌توانیم از ژیروسکوپ برای فیلتر پیشرفته‌تر استفاده کنیم
        // If needed, we can use gyroscope for more advanced filtering
      },
      onError: (e, s) {
        if (kDebugMode) {
          print('خطا در gyroscope: $e');
          // Error in gyroscope
        }
      },
    );

    _isListening = true;

    if (kDebugMode) {
      print('MotionService listening started');
    }
  }

  /// توقف listening به سنسورها (بدون dispose کردن)
  /// Stop listening to sensors (without disposing)
  Future<void> stop() async {
    if (!_isListening) return;

    await _accelerometerSub?.cancel();
    await _gyroscopeSub?.cancel();
    _accelerometerSub = null;
    _gyroscopeSub = null;

    _isListening = false;

    if (kDebugMode) {
      print('MotionService listening stopped');
    }
  }

  /// شروع مجدد listening به سنسورها
  /// Restart listening to sensors
  void start() {
    if (_isListening) return;
    _start();
  }

  void _processSensors() {
    final acc = _lastAccelerometer;
    if (acc == null) return;

    // محاسبه pitch از روی شتاب‌سنج
    // Calculate pitch from accelerometer
    // فرمول تقریبی:
    // Approximate formula:
    // pitch = atan2(-ax, sqrt(ay^2 + az^2))
    final ax = acc.x;
    final ay = acc.y;
    final az = acc.z;

    final pitchRad = math.atan2(-ax, math.sqrt(ay * ay + az * az));
    final pitchDeg = pitchRad * 180 / math.pi;

    _lastPitch = pitchDeg;

    // تشخیص تقریبی شیب
    // Approximate slope detection
    final slope = _detectSlopeFromPitch(pitchDeg);
    _lastSlope = slope;

    final data = MotionData(
      accelerometer: acc,
      gyroscope: _lastGyroscope,
      pitchDegrees: pitchDeg,
      slopeDirection: slope,
      timestamp: DateTime.now(),
    );

    _motionController.add(data);

    if (kDebugMode) {
      print(
        'Motion | pitch=${pitchDeg.toStringAsFixed(1)}°, slope=$slope, '
        'acc=(${ax.toStringAsFixed(2)}, ${ay.toStringAsFixed(2)}, ${az.toStringAsFixed(2)})',
      );
    }
  }

  SlopeDirection _detectSlopeFromPitch(double pitchDeg) {
    // فرض مهم: گوشی در راستای حرکت (به سمت جلو) نگه داشته شده باشد.
    // Important assumption: The phone should be held in the direction of movement (forward).
    // اگر گوشی خیلی چرخانده شود، این تشخیص دقیق نخواهد بود.
    // If the phone is rotated too much, this detection will not be accurate.

    if (pitchDeg.abs() <= _pitchFlatThreshold) {
      return SlopeDirection.flat;
    }

    if (pitchDeg >= _pitchUphillThreshold) {
      return SlopeDirection.uphill;
    }

    if (pitchDeg <= _pitchDownhillThreshold) {
      return SlopeDirection.downhill;
    }

    return SlopeDirection.unknown;
  }

  /// توقف گوش دادن به سنسورها و آزاد کردن منابع
  /// Stop listening to sensors and dispose resources
  Future<void> dispose() async {
    await stop();
    await _motionController.close();

    if (kDebugMode) {
      print('MotionService disposed');
    }
  }
}


