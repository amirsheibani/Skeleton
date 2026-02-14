import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// ============================================================================
/// MOTION SERVICE - مستند جامع سرویس تشخیص حرکت
/// ============================================================================
///
/// این سرویس با استفاده از سنسورهای شتاب‌سنج (Accelerometer) و ژیروسکوپ (Gyroscope)
/// گوشی، جهت حرکت عمودی را تشخیص می‌دهد و وضعیت را به صورت سربالایی (uphill)،
/// سرپایینی (downhill) یا ثابت (flat) گزارش می‌کند.
///
/// This service uses accelerometer and gyroscope sensors to detect vertical
/// movement direction and reports the status as uphill, downhill, or flat.
///
/// ----------------------------------------------------------------------------
/// نحوه کار / How It Works
/// ----------------------------------------------------------------------------
///
/// 1. دریافت داده‌های سنسور / Sensor Data Collection:
///    - شتاب‌سنج (Accelerometer): شتاب در سه محور X, Y, Z را بر حسب m/s² می‌دهد
///    - ژیروسکوپ (Gyroscope): سرعت چرخش در سه محور را بر حسب rad/s می‌دهد
///
/// 2. محاسبه Pitch (زاویه خم شدن):
///    Pitch زاویه‌ای است که نشان می‌دهد گوشی چقدر به سمت بالا یا پایین خم شده است.
///
///    فرمول محاسبه Pitch:
///    ```
///    pitch = atan2(ay, sqrt(ax² + az²))
///    ```
///    که در آن:
///    - ax: شتاب در محور X (چپ/راست)
///    - ay: شتاب در محور Y (بالا/پایین)
///    - az: شتاب در محور Z (جلو/عقب)
///
///    نتیجه به درجه (degrees) تبدیل می‌شود:
///    ```
///    pitchDegrees = pitchRadians × (180 / π)
///    ```
///
/// 3. تشخیص حرکت بر اساس تغییرات Pitch:
///    به جای استفاده از مقدار مطلق pitch، از سرعت تغییر pitch استفاده می‌کنیم
///    تا حرکت واقعی را تشخیص دهیم (نه فقط زاویه ثابت).
///
///    محاسبه سرعت تغییر Pitch:
///    ```
///    deltaPitch = pitchCurrent - pitchPrevious
///    deltaTime = timeCurrent - timePrevious
///    pitchVelocity = deltaPitch / deltaTime  (درجه بر ثانیه)
///    ```
///
/// 4. فیلتر نویز با استفاده از میانگین:
///    برای کاهش نویز و افزایش دقت، از تاریخچه 5 نمونه آخر استفاده می‌کنیم:
///    ```
///    avgPitchVelocity = (v1 + v2 + v3 + v4 + v5) / 5
///    ```
///
/// 5. تشخیص جهت حرکت:
///    - اگر avgPitchVelocity > +2.0 °/s  → سربالایی (uphill)
///    - اگر avgPitchVelocity < -2.0 °/s  → سرپایینی (downhill)
///    - اگر |avgPitchVelocity| < 0.5 °/s → ثابت (flat)
///
/// 6. محاسبه سرعت تغییرات در هر سه محور:
///    برای هر محور X, Y, Z، سرعت تغییر شتاب محاسبه می‌شود:
///    ```
///    velocityX = (ax_current - ax_previous) / deltaTime  (m/s³)
///    velocityY = (ay_current - ay_previous) / deltaTime  (m/s³)
///    velocityZ = (az_current - az_previous) / deltaTime  (m/s³)
///    ```
///
///    این مقادیر نشان می‌دهند که شتاب در هر محور با چه سرعتی در حال تغییر است.
///
/// ----------------------------------------------------------------------------
/// پارامترهای قابل تنظیم / Configurable Parameters
/// ----------------------------------------------------------------------------
///
/// - _velocityThreshold: 2.0 °/s
///   حداقل سرعت تغییر pitch برای تشخیص حرکت (سربالایی/سرپایینی)
///
/// - _flatVelocityThreshold: 0.5 °/s
///   حداکثر سرعت تغییر pitch برای تشخیص حالت ثابت
///
/// - _samplesForStable: 5
///   تعداد نمونه‌های مورد استفاده برای محاسبه میانگین (فیلتر نویز)
///
/// ----------------------------------------------------------------------------
/// نحوه استفاده / Usage
/// ----------------------------------------------------------------------------
///
/// ```dart
/// // دریافت سرویس از DI
/// final motionService = getIt<MotionService>();
///
/// // گوش دادن به استریم داده‌ها
/// motionService.motionStream.listen((data) {
///   print('Slope: ${data.slopeDirection}');
///   print('Pitch: ${data.pitchDegrees}°');
///   print('Velocity X: ${data.velocityX} m/s³');
///   print('Velocity Y: ${data.velocityY} m/s³');
///   print('Velocity Z: ${data.velocityZ} m/s³');
/// });
///
/// // شروع/توقف listening
/// motionService.start();  // شروع
/// motionService.stop();   // توقف
/// ```
///
/// ----------------------------------------------------------------------------
/// نکات مهم / Important Notes
/// ----------------------------------------------------------------------------
///
/// 1. این سرویس به صورت خودکار در constructor شروع می‌شود.
///
/// 2. برای تشخیص دقیق‌تر، گوشی باید در حالت Portrait نگه داشته شود.
///
/// 3. تشخیص بر اساس حرکت است، نه زاویه ثابت. یعنی:
///    - وقتی گوشی را به سمت بالا حرکت می‌دهید → سربالایی
///    - وقتی متوقف می‌شوید → ثابت
///    - وقتی به سمت پایین حرکت می‌دهید → سرپایینی
///
/// 4. سرعت تغییرات (velocityX, velocityY, velocityZ) در اولین نمونه null است
///    چون نیاز به داده قبلی برای محاسبه دارد.
///
/// 5. برای dispose کردن سرویس، متد dispose() را فراخوانی کنید.
///
/// ============================================================================

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
  
  // سرعت تغییرات در هر سه محور (m/s² per second یا m/s³)
  // Velocity changes in each axis (m/s² per second or m/s³)
  final double? velocityX; // سرعت تغییر در محور X / Velocity change in X axis
  final double? velocityY; // سرعت تغییر در محور Y / Velocity change in Y axis
  final double? velocityZ; // سرعت تغییر در محور Z / Velocity change in Z axis

  const MotionData({
    required this.accelerometer,
    required this.gyroscope,
    required this.pitchDegrees,
    required this.slopeDirection,
    required this.timestamp,
    this.velocityX,
    this.velocityY,
    this.velocityZ,
  });
}

class MotionService {
  // تنظیمات فیلتر و آستانه‌ها / Filter settings and thresholds
  static const double _velocityThreshold = 2.0; // درجه بر ثانیه - حداقل تغییر pitch برای تشخیص حرکت
  static const double _flatVelocityThreshold = 0.5; // درجه بر ثانیه - اگر کمتر از این باشد = ثابت
  static const int _samplesForStable = 5; // تعداد نمونه‌ها برای تشخیص ثابت بودن

  StreamSubscription<AccelerometerEvent>? _accelerometerSub;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSub;

  final _motionController = StreamController<MotionData>.broadcast();

  /// استریم داده‌های پردازش شده حرکت
  /// Stream of processed motion data
  Stream<MotionData> get motionStream => _motionController.stream;

  AccelerometerEvent? _lastAccelerometer;
  AccelerometerEvent? _previousAccelerometer; // برای محاسبه سرعت تغییرات / For calculating velocity changes
  GyroscopeEvent? _lastGyroscope;

  double _lastPitch = 0; // آخرین pitch محاسبه شده (درجه) / Last calculated pitch (degrees)
  double _previousPitch = 0; // pitch قبلی برای محاسبه تغییرات / Previous pitch for calculating changes
  SlopeDirection _lastSlope = SlopeDirection.unknown;
  
  // برای تشخیص حرکت / For motion detection
  List<double> _pitchVelocityHistory = []; // تاریخچه سرعت تغییر pitch / Pitch change velocity history
  DateTime? _lastTimestamp;

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

    // گوش دادن به ژیروسکوپ برای تشخیص بهتر حرکت
    // Listening to gyroscope for better motion detection
    _gyroscopeSub = gyroscopeEventStream().listen(
      (event) {
        _lastGyroscope = event;
        _processSensors(); // پردازش با هر تغییر gyroscope هم
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

    // پاک کردن تاریخچه برای شروع مجدد
    // Clear history for restart
    _pitchVelocityHistory.clear();
    _previousPitch = 0;
    _previousAccelerometer = null;
    _lastTimestamp = null;

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

    final now = DateTime.now();
    final ax = acc.x;
    final ay = acc.y;
    final az = acc.z;

    // محاسبه pitch برای نمایش
    // Calculate pitch for display
    final pitchRad = math.atan2(ay, math.sqrt(ax * ax + az * az));
    final pitchDeg = pitchRad * 180 / math.pi;
    _lastPitch = pitchDeg;

    // تشخیص حرکت بر اساس تغییرات pitch
    // Motion detection based on pitch changes
    // وقتی pitch افزایش می‌یابد = گوشی به سمت بالا می‌رود = سربالایی
    // When pitch increases = phone moves upward = uphill
    // وقتی pitch کاهش می‌یابد = گوشی به سمت پایین می‌رود = سرپایینی
    // When pitch decreases = phone moves downward = downhill
    SlopeDirection slope = SlopeDirection.unknown;
    
    // محاسبه سرعت تغییرات در هر سه محور
    // Calculate velocity changes in each axis
    double? velocityX;
    double? velocityY;
    double? velocityZ;
    
    if (_lastTimestamp != null) {
      final deltaTime = (now.difference(_lastTimestamp!).inMilliseconds / 1000.0);
      
      if (deltaTime > 0) {
        // محاسبه تغییرات pitch (سرعت تغییر زاویه)
        // Calculate pitch changes (angular velocity)
        final deltaPitch = pitchDeg - _previousPitch;
        final pitchVelocity = deltaPitch / deltaTime; // درجه بر ثانیه / degrees per second
        
        // اضافه کردن به تاریخچه (برای فیلتر نویز)
        // Add to history (for noise filtering)
        _pitchVelocityHistory.add(pitchVelocity);
        if (_pitchVelocityHistory.length > _samplesForStable) {
          _pitchVelocityHistory.removeAt(0);
        }
        
        // محاسبه میانگین سرعت برای تشخیص بهتر
        // Calculate average velocity for better detection
        final avgPitchVelocity = _pitchVelocityHistory.reduce((a, b) => a + b) / _pitchVelocityHistory.length;
        
        // تشخیص جهت حرکت
        // Detect movement direction
        if (avgPitchVelocity.abs() < _flatVelocityThreshold) {
          // سرعت تغییر نزدیک به صفر = ثابت
          // Change velocity near zero = stationary
          slope = SlopeDirection.flat;
        } else if (avgPitchVelocity > _velocityThreshold) {
          // سرعت تغییر مثبت = pitch در حال افزایش = حرکت به سمت بالا = سربالایی
          // Positive change velocity = pitch increasing = upward movement = uphill
          slope = SlopeDirection.uphill;
        } else if (avgPitchVelocity < -_velocityThreshold) {
          // سرعت تغییر منفی = pitch در حال کاهش = حرکت به سمت پایین = سرپایینی
          // Negative change velocity = pitch decreasing = downward movement = downhill
          slope = SlopeDirection.downhill;
        } else {
          // در حالت بینابینی = ثابت
          // In between = stationary
          slope = SlopeDirection.flat;
        }
        
        // محاسبه سرعت تغییرات در هر سه محور (اگر accelerometer قبلی وجود داشته باشد)
        // Calculate velocity changes in each axis (if previous accelerometer exists)
        if (_previousAccelerometer != null) {
          velocityX = (ax - _previousAccelerometer!.x) / deltaTime; // m/s³
          velocityY = (ay - _previousAccelerometer!.y) / deltaTime; // m/s³
          velocityZ = (az - _previousAccelerometer!.z) / deltaTime; // m/s³
        }
      }
    } else {
      // اولین نمونه = هنوز نمی‌توانیم حرکت را تشخیص دهیم
      // First sample = can't detect movement yet
      slope = SlopeDirection.flat;
    }

    // ذخیره مقادیر قبلی
    // Save previous values
    _previousPitch = pitchDeg;
    _previousAccelerometer = acc;
    _lastTimestamp = now;
    _lastSlope = slope;

    final data = MotionData(
      accelerometer: acc,
      gyroscope: _lastGyroscope,
      pitchDegrees: pitchDeg,
      slopeDirection: slope,
      timestamp: now,
      velocityX: velocityX,
      velocityY: velocityY,
      velocityZ: velocityZ,
    );

    _motionController.add(data);

    if (kDebugMode) {
      final avgPitchVel = _pitchVelocityHistory.isNotEmpty
          ? (_pitchVelocityHistory.reduce((a, b) => a + b) / _pitchVelocityHistory.length)
          : 0.0;
      print(
        'Motion | pitch=${pitchDeg.toStringAsFixed(1)}°, slope=$slope, '
        'pitchVelocity=${avgPitchVel.toStringAsFixed(3)} °/s, '
        'acc=(${ax.toStringAsFixed(2)}, ${ay.toStringAsFixed(2)}, ${az.toStringAsFixed(2)}), '
        'vel=(${velocityX?.toStringAsFixed(3) ?? 'N/A'}, ${velocityY?.toStringAsFixed(3) ?? 'N/A'}, ${velocityZ?.toStringAsFixed(3) ?? 'N/A'}) m/s³',
      );
    }
  }

  /// توقف گوش دادن به سنسورها و آزاد کردن منابع
  /// Stop listening to sensors and dispose resources
  Future<void> dispose() async {
    await stop();
    await _motionController.close();
    
    // پاک کردن تاریخچه / Clear history
    _pitchVelocityHistory.clear();
    _previousPitch = 0;
    _previousAccelerometer = null;
    _lastTimestamp = null;

    if (kDebugMode) {
      print('MotionService disposed');
    }
  }
}


