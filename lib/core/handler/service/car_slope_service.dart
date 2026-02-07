import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import 'gps_service_handler.dart';
import 'motion_service_handler.dart';

/// ============================================================================
/// CAR SLOPE SERVICE - مستند جامع سرویس تشخیص شیب برای خودرو
/// ============================================================================
///
/// این سرویس با استفاده از تکنیک Sensor Fusion، داده‌های GPS (تغییر ارتفاع و فاصله)
/// را با داده‌های IMU (شتاب‌سنج و ژیروسکوپ) ترکیب می‌کند تا شیب جاده را با دقت
/// مناسب برای خودرو تشخیص دهد. این ترکیب باعث می‌شود که دقت تشخیص بیشتر از
/// استفاده از هر کدام به تنهایی باشد.
///
/// This service uses Sensor Fusion technique to combine GPS data (altitude change
/// and distance) with IMU data (accelerometer and gyroscope) to detect road slope
/// with appropriate accuracy for vehicles. This combination provides better accuracy
/// than using either source alone.
///
/// ----------------------------------------------------------------------------
/// نحوه کار / How It Works
/// ----------------------------------------------------------------------------
///
/// این سرویس از دو منبع داده استفاده می‌کند:
///
/// This service uses two data sources:
///
/// 1. GPS (Global Positioning System):
///    - تغییر ارتفاع (Δh) بین دو نقطه GPS
///    - فاصله افقی (d) بین دو نقطه
///    - Altitude change (Δh) between two GPS points
///    - Horizontal distance (d) between two points
///
/// 2. IMU (Inertial Measurement Unit):
///    - Pitch angle از شتاب‌سنج (زاویه خم شدن به جلو/عقب)
///    - Pitch angle from accelerometer (forward/backward tilt angle)
///
/// سپس این دو منبع را با استفاده از Weighted Average ترکیب می‌کند.
///
/// Then combines these two sources using Weighted Average.
///
/// ----------------------------------------------------------------------------
/// محاسبه GPS Grade / GPS Grade Calculation
/// ----------------------------------------------------------------------------
///
/// GPS Grade از تغییر ارتفاع و فاصله افقی محاسبه می‌شود:
///
/// GPS Grade is calculated from altitude change and horizontal distance:
///
/// ```
/// GPS Grade = Δh / d
/// ```
///
/// که در آن:
/// - Δh = تغییر ارتفاع (متر) = altitude_current - altitude_previous
/// - d = فاصله افقی بین دو نقطه GPS (متر)
///
/// Where:
/// - Δh = Altitude change (meters) = altitude_current - altitude_previous
/// - d = Horizontal distance between two GPS points (meters)
///
/// این فرمول تقریباً برابر با tan(θ) است که θ زاویه شیب است.
/// برای زاویه‌های کوچک (< 15°)، tan(θ) ≈ θ (به رادیان) ≈ درصد شیب.
///
/// This formula is approximately equal to tan(θ) where θ is the slope angle.
/// For small angles (< 15°), tan(θ) ≈ θ (in radians) ≈ slope percentage.
///
/// مثال:
/// ```
/// نقطه قبلی: altitude = 1200m, latitude = 35.6892, longitude = 51.3890
/// نقطه فعلی: altitude = 1250m, latitude = 35.6900, longitude = 51.3900
/// 
/// Previous point: altitude = 1200m
/// Current point: altitude = 1250m
/// 
/// Δh = 1250 - 1200 = 50 متر
/// d = فاصله بین دو نقطه (با استفاده از Haversine) ≈ 100 متر
/// 
/// GPS Grade = 50 / 100 = 0.5 = 50% شیب (خیلی تند!)
/// 
/// در واقعیت، جاده‌ها معمولاً شیب 3-10% دارند.
/// In reality, roads usually have 3-10% slope.
/// ```
///
/// محدودیت‌ها:
/// - GPS altitude دقت کمتری نسبت به GPS position دارد (معمولاً ±10-20 متر)
/// - نیاز به حداقل فاصله بین نقاط GPS (20 متر) برای کاهش نویز
/// - فقط وقتی سرعت خودرو > 10 km/h باشد اعتماد می‌کنیم
///
/// Limitations:
/// - GPS altitude has lower accuracy than GPS position (usually ±10-20 meters)
/// - Requires minimum distance between GPS points (20 meters) to reduce noise
/// - Only trusted when vehicle speed > 10 km/h
///
/// ----------------------------------------------------------------------------
/// محاسبه IMU Grade / IMU Grade Calculation
/// ----------------------------------------------------------------------------
///
/// IMU Grade از pitch angle (زاویه خم شدن) محاسبه می‌شود:
///
/// IMU Grade is calculated from pitch angle (tilt angle):
///
/// ```
/// IMU Grade = tan(pitch_radians)
/// ```
///
/// که در آن:
/// - pitch_radians = pitch_degrees × (π / 180)
/// - pitch_degrees: زاویه pitch از MotionService (درجه)
///
/// Where:
/// - pitch_radians = pitch_degrees × (π / 180)
/// - pitch_degrees: Pitch angle from MotionService (degrees)
///
/// برای زاویه‌های کوچک (< 15°):
/// ```
/// tan(θ) ≈ θ (به رادیان) ≈ θ × (180 / π) (به درجه) / 100
/// ```
///
/// For small angles (< 15°):
/// ```
/// tan(θ) ≈ θ (in radians) ≈ θ × (180 / π) (in degrees) / 100
/// ```
///
/// مثال:
/// ```
/// pitch = 5° (سربالایی)
/// pitch = 5° (uphill)
/// 
/// pitch_radians = 5 × (π / 180) = 0.0873 rad
/// IMU Grade = tan(0.0873) = 0.0875 ≈ 8.75% شیب
/// 
/// pitch = -3° (سرپایینی)
/// pitch = -3° (downhill)
/// 
/// pitch_radians = -3 × (π / 180) = -0.0524 rad
/// IMU Grade = tan(-0.0524) = -0.0524 ≈ -5.24% شیب
/// ```
///
/// مزایا:
/// - پاسخ سریع به تغییرات شیب
/// - دقت خوب برای زاویه‌های کوچک تا متوسط
///
/// Advantages:
/// - Fast response to slope changes
/// - Good accuracy for small to medium angles
///
/// محدودیت‌ها:
/// - تحت تأثیر شتاب/کاهش سرعت خودرو قرار می‌گیرد
/// - نیاز به کالیبراسیون (صفر کردن در حالت صاف)
/// - نویز در حالت ثابت
///
/// Limitations:
/// - Affected by vehicle acceleration/deceleration
/// - Requires calibration (zeroing on flat surface)
/// - Noise when stationary
///
/// ----------------------------------------------------------------------------
/// Sensor Fusion (ترکیب GPS و IMU) / Sensor Fusion Algorithm
/// ----------------------------------------------------------------------------
///
/// برای به دست آوردن بهترین نتیجه، از Weighted Average استفاده می‌کنیم:
///
/// To get the best result, we use Weighted Average:
///
/// ```
/// Fused Grade = (GPS_Weight × GPS_Grade) + (IMU_Weight × IMU_Grade)
/// ```
///
/// که در آن:
/// - GPS_Weight = 0.7 (70%)
/// - IMU_Weight = 0.3 (30%)
///
/// Where:
/// - GPS_Weight = 0.7 (70%)
/// - IMU_Weight = 0.3 (30%)
///
/// دلیل انتخاب این وزن‌ها:
/// - GPS برای اندازه‌گیری‌های بلندمدت دقیق‌تر است (کمتر تحت تأثیر نویز)
/// - IMU برای تغییرات سریع بهتر است اما نویز بیشتری دارد
/// - ترکیب 70/30 تعادل خوبی بین دقت و پاسخ‌دهی سریع ایجاد می‌کند
///
/// Reason for these weights:
/// - GPS is more accurate for long-term measurements (less affected by noise)
/// - IMU is better for rapid changes but has more noise
/// - 70/30 combination provides good balance between accuracy and fast response
///
/// مثال:
/// ```
/// GPS Grade = 0.05 (5% سربالایی)
/// IMU Grade = 0.06 (6% سربالایی)
/// 
/// GPS Grade = 0.05 (5% uphill)
/// IMU Grade = 0.06 (6% uphill)
/// 
/// Fused Grade = (0.7 × 0.05) + (0.3 × 0.06)
///             = 0.035 + 0.018
///             = 0.053 = 5.3% شیب
/// ```
///
/// حالت‌های خاص:
/// - اگر فقط GPS موجود باشد: Fused Grade = GPS Grade
/// - اگر فقط IMU موجود باشد: Fused Grade = IMU Grade
/// - اگر هیچکدام موجود نباشد: Fused Grade = 0.0
///
/// Special cases:
/// - If only GPS available: Fused Grade = GPS Grade
/// - If only IMU available: Fused Grade = IMU Grade
/// - If neither available: Fused Grade = 0.0
///
/// ----------------------------------------------------------------------------
/// تشخیص جهت شیب / Slope Direction Detection
/// ----------------------------------------------------------------------------
///
/// بعد از محاسبه Fused Grade، جهت شیب تشخیص داده می‌شود:
///
/// After calculating Fused Grade, slope direction is detected:
///
/// ```
/// اگر |Fused Grade| < 0.03 (3%)  → Flat (صاف)
/// اگر Fused Grade > 0.03          → Uphill (سربالایی)
/// اگر Fused Grade < -0.03         → Downhill (سرپایینی)
/// در غیر این صورت                 → Unknown (نامشخص)
/// ```
///
/// ```
/// If |Fused Grade| < 0.03 (3%)  → Flat
/// If Fused Grade > 0.03          → Uphill
/// If Fused Grade < -0.03         → Downhill
/// Otherwise                      → Unknown
/// ```
///
/// Threshold 3% انتخاب شده چون:
/// - جاده‌های صاف معمولاً شیب < 3% دارند
/// - شیب 3% قابل توجه است اما هنوز راحت رانندگی می‌شود
/// - کاهش false positive برای تشخیص صاف
///
/// 3% threshold is chosen because:
/// - Flat roads usually have < 3% slope
/// - 3% slope is noticeable but still comfortable to drive
/// - Reduces false positives for flat detection
///
/// ----------------------------------------------------------------------------
/// پارامترهای قابل تنظیم / Configurable Parameters
/// ----------------------------------------------------------------------------
///
/// 1. _minSpeedKmh = 10.0 km/h
///    حداقل سرعت برای اعتماد به محاسبات شیب
///    Minimum speed to trust slope calculations
///    دلیل: در سرعت پایین، GPS altitude و IMU pitch نویز زیادی دارند
///    Reason: At low speeds, GPS altitude and IMU pitch have high noise
///
/// 2. _minDistanceMeters = 20.0 meters
///    حداقل فاصله بین نقاط GPS برای محاسبه grade
///    Minimum distance between GPS points to calculate grade
///    دلیل: کاهش نویز در محاسبه GPS Grade
///    Reason: Reduces noise in GPS Grade calculation
///
/// 3. _gradeThreshold = 0.03 (3%)
///    حداقل شیب برای تشخیص سربالایی/سرپایینی (نه صاف)
///    Minimum slope to detect uphill/downhill (not flat)
///
/// 4. _gpsWeight = 0.7 (70%)
///    وزن GPS در ترکیب نهایی
///    GPS weight in final combination
///
/// 5. _imuWeight = 0.3 (30%)
///    وزن IMU در ترکیب نهایی
///    IMU weight in final combination
///
/// ----------------------------------------------------------------------------
/// نحوه استفاده / Usage
/// ----------------------------------------------------------------------------
///
/// ```dart
/// // دریافت سرویس از DI
/// final carSlopeService = getIt<CarSlopeService>();
///
/// // گوش دادن به stream داده‌های شیب
/// carSlopeService.slopeStream.listen((slopeData) {
///   print('Direction: ${slopeData.direction}');
///   print('Fused Grade: ${(slopeData.fusedGrade * 100).toStringAsFixed(1)}%');
///   print('GPS Grade: ${slopeData.gpsGrade != null ? (slopeData.gpsGrade! * 100).toStringAsFixed(1) : 'N/A'}%');
///   print('IMU Pitch: ${slopeData.imuPitchDegrees?.toStringAsFixed(1) ?? 'N/A'}°');
///   print('Speed: ${slopeData.speedKmh.toStringAsFixed(1)} km/h');
/// });
///
/// // شروع/توقف listening
/// await carSlopeService.start();  // شروع
/// await carSlopeService.stop();   // توقف
///
/// // نکته مهم: GPS service باید قبل از استفاده از این سرویس، listening را شروع کرده باشد
/// // Important note: GPS service must have started listening before using this service
/// ```
///
/// ----------------------------------------------------------------------------
/// نکات مهم / Important Notes
/// ----------------------------------------------------------------------------
///
/// 1. وابستگی‌ها:
///    - این سرویس به GPSService و MotionService وابسته است
///    - GPS service باید listening را شروع کرده باشد
///    - MotionService به صورت خودکار در constructor شروع می‌شود
///
/// 2. دقت:
///    - دقت در سرعت‌های بالا (> 30 km/h) بهتر است
///    - در سرعت‌های پایین (< 10 km/h) ممکن است unreliable باشد
///    - GPS altitude دقت کمتری نسبت به GPS position دارد
///
/// 3. Performance:
///    - این سرویس به صورت خودکار در constructor شروع می‌شود
///    - برای صرفه‌جویی در battery، می‌توانید stop() را صدا بزنید
///
/// 4. محدودیت‌ها:
///    - در تونل‌ها یا مناطق بدون GPS signal، فقط IMU استفاده می‌شود
///    - در حالت ثابت یا سرعت پایین، نتیجه ممکن است unreliable باشد
///    - GPS altitude ممکن است در مناطق کوهستانی دقیق نباشد
///
/// 5. کالیبراسیون:
///    - برای دقت بهتر، می‌توانید IMU را در یک جاده صاف کالیبره کنید
///    - اما این سرویس به صورت پیش‌فرض بدون کالیبراسیون کار می‌کند
///
/// ----------------------------------------------------------------------------
/// مثال محاسبه کامل / Complete Calculation Example
/// ----------------------------------------------------------------------------
///
/// فرض کنید:
/// ```
/// GPS Point 1: altitude = 1000m, lat = 35.6892, lon = 51.3890
/// GPS Point 2: altitude = 1030m, lat = 35.6900, lon = 51.3900
/// فاصله بین دو نقطه: 100 متر
/// سرعت خودرو: 50 km/h
/// IMU Pitch: 2.5° (سربالایی)
/// ```
///
/// Assume:
/// ```
/// GPS Point 1: altitude = 1000m, lat = 35.6892, lon = 51.3890
/// GPS Point 2: altitude = 1030m, lat = 35.6900, lon = 51.3900
/// Distance between points: 100 meters
/// Vehicle speed: 50 km/h
/// IMU Pitch: 2.5° (uphill)
/// ```
///
/// محاسبات:
/// ```
/// 1. GPS Grade:
///    Δh = 1030 - 1000 = 30 متر
///    d = 100 متر
///    GPS Grade = 30 / 100 = 0.30 = 30% (خیلی تند!)
/// 
/// 2. IMU Grade:
///    pitch_radians = 2.5 × (π / 180) = 0.0436 rad
///    IMU Grade = tan(0.0436) = 0.0436 ≈ 4.36%
/// 
/// 3. Fused Grade:
///    Fused Grade = (0.7 × 0.30) + (0.3 × 0.0436)
///                = 0.21 + 0.0131
///                = 0.2231 = 22.31% شیب
/// 
/// 4. Direction:
///    چون Fused Grade (0.2231) > 0.03 → Uphill (سربالایی)
/// ```
///
/// توجه: در این مثال، GPS Grade (30%) خیلی بیشتر از IMU Grade (4.36%) است.
/// این ممکن است به دلیل خطا در GPS altitude باشد. با استفاده از Sensor Fusion
/// و وزن بیشتر برای GPS، نتیجه نهایی (22.31%) بین دو مقدار است اما به GPS
/// نزدیک‌تر است.
///
/// Note: In this example, GPS Grade (30%) is much higher than IMU Grade (4.36%).
/// This might be due to GPS altitude error. Using Sensor Fusion with higher weight
/// for GPS, the final result (22.31%) is between the two values but closer to GPS.
///
/// ============================================================================

@module
abstract class CarSlopeServiceModule {
  @lazySingleton
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
    // نکته: MotionService به صورت خودکار در constructor شروع می‌شود
    // Note: MotionService automatically starts in its constructor
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
    // نکته مهم: GPS service باید قبل از استفاده از این سرویس، listening را شروع کرده باشد
    // (معمولاً در notifier یا صفحه مربوطه انجام می‌شود)
    // Important note: GPS service must have started listening before using this service
    // (usually done in notifier or related page)
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

  /// توقف listening به stream ها (بدون dispose کردن)
  /// Stop listening to streams (without disposing)
  Future<void> stop() async {
    await _gpsSub?.cancel();
    _gpsSub = null;
    await _motionSub?.cancel();
    _motionSub = null;

    if (kDebugMode) {
      print('CarSlopeService stopped');
    }
  }

  /// شروع مجدد listening به stream ها
  /// Restart listening to streams
  Future<void> start() async {
    if (_gpsSub != null || _motionSub != null) {
      // اگر قبلاً listening بود، ابتدا stop می‌کنیم
      // If already listening, stop first
      await stop();
    }
    _start();
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
  /// 
  /// نکته مهم: این متد فقط subscription های این سرویس را cancel می‌کند.
  /// سرویس‌های GPS و Motion که به عنوان dependency تزریق شده‌اند،
  /// singleton هستند و نباید dispose شوند چون ممکن است در جاهای دیگر
  /// هم استفاده شوند.
  ///
  /// Important note: This method only cancels subscriptions of this service.
  /// GPS and Motion services that are injected as dependencies are singletons
  /// and should not be disposed as they may be used elsewhere.
  Future<void> dispose() async {
    await _gpsSub?.cancel();
    _gpsSub = null;
    await _motionSub?.cancel();
    _motionSub = null;
    await _slopeController.close();

    // پاک کردن state
    // Clear state
    _lastMotion = null;
    _lastGpsForGrade = null;
    _lastFusedGrade = 0.0;
    _lastDirection = CarSlopeDirection.unknown;

    if (kDebugMode) {
      print('CarSlopeService disposed');
    }
  }
}


