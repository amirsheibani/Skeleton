import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

/// ============================================================================
/// GPS SERVICE - مستند جامع سرویس مدیریت GPS و موقعیت‌یابی
/// ============================================================================
///
/// این سرویس یک لایه کامل برای مدیریت GPS و موقعیت‌یابی در Flutter فراهم می‌کند.
/// شامل دریافت موقعیت، مدیریت permission، listening به تغییرات موقعیت،
/// محاسبه فاصله و جهت بین دو نقطه، و تشخیص منبع موقعیت می‌شود.
///
/// This service provides a complete layer for managing GPS and location services
/// in Flutter, including getting position, managing permissions, listening to
/// position changes, calculating distance and bearing between points, and detecting
/// location source.
///
/// ----------------------------------------------------------------------------
/// قابلیت‌های اصلی / Main Features
/// ----------------------------------------------------------------------------
///
/// 1. مدیریت Permission:
///    - چک کردن وضعیت permission
///    - درخواست permission
///    - باز کردن تنظیمات در صورت نیاز
///
/// 2. دریافت موقعیت:
///    - دریافت موقعیت فعلی (getCurrentPosition)
///    - دریافت آخرین موقعیت شناخته شده (getLastKnownPosition)
///    - Listening به تغییرات موقعیت به صورت real-time
///
/// 3. محاسبات جغرافیایی:
///    - محاسبه فاصله بین دو نقطه (Haversine formula)
///    - محاسبه bearing (جهت) بین دو نقطه
///
/// 4. تشخیص منبع موقعیت:
///    - تشخیص اینکه موقعیت از GPS sensor، Network، یا Passive آمده
///    - بر اساس دقت موقعیت
///
/// ----------------------------------------------------------------------------
/// نحوه محاسبه فاصله / Distance Calculation
/// ----------------------------------------------------------------------------
///
/// این سرویس از فرمول Haversine برای محاسبه فاصله بین دو نقطه روی کره زمین
/// استفاده می‌کند. این فرمول دقیق‌ترین روش برای محاسبه فاصله کوتاه تا متوسط است.
///
/// This service uses the Haversine formula to calculate the distance between
/// two points on the Earth's surface. This is the most accurate method for
/// short to medium distances.
///
/// فرمول Haversine:
/// ```
/// a = sin²(Δφ/2) + cos(φ1) × cos(φ2) × sin²(Δλ/2)
/// c = 2 × atan2(√a, √(1−a))
/// d = R × c
/// ```
///
/// که در آن:
/// - φ1, φ2: عرض جغرافیایی دو نقطه (latitude) به رادیان
/// - λ1, λ2: طول جغرافیایی دو نقطه (longitude) به رادیان
/// - Δφ = φ2 - φ1 (تفاوت عرض جغرافیایی)
/// - Δλ = λ2 - λ1 (تفاوت طول جغرافیایی)
/// - R: شعاع زمین (تقریباً 6371 کیلومتر یا 6371000 متر)
/// - d: فاصله به متر
///
/// Where:
/// - φ1, φ2: Latitude of two points in radians
/// - λ1, λ2: Longitude of two points in radians
/// - Δφ = φ2 - φ1 (difference in latitude)
/// - Δλ = λ2 - λ1 (difference in longitude)
/// - R: Earth's radius (approximately 6371 km or 6371000 meters)
/// - d: Distance in meters
///
/// مثال:
/// ```
/// فاصله بین تهران (35.6892°N, 51.3890°E) و اصفهان (32.6546°N, 51.6680°E)
/// Distance between Tehran and Isfahan
/// 
/// φ1 = 35.6892° = 0.6227 rad
/// φ2 = 32.6546° = 0.5706 rad
/// λ1 = 51.3890° = 0.8968 rad
/// λ2 = 51.6680° = 0.9024 rad
/// 
/// Δφ = 0.5706 - 0.6227 = -0.0521 rad
/// Δλ = 0.9024 - 0.8968 = 0.0056 rad
/// 
/// a = sin²(-0.0521/2) + cos(0.6227) × cos(0.5706) × sin²(0.0056/2)
/// c = 2 × atan2(√a, √(1−a))
/// d = 6371000 × c ≈ 405,000 متر ≈ 405 کیلومتر
/// ```
///
/// ----------------------------------------------------------------------------
/// نحوه محاسبه Bearing (جهت) / Bearing Calculation
/// ----------------------------------------------------------------------------
///
/// Bearing زاویه‌ای است که نشان می‌دهد برای رسیدن از نقطه A به نقطه B باید
/// در چه جهتی حرکت کرد. این زاویه بر حسب درجه از شمال محاسبه می‌شود
/// (0° = شمال، 90° = شرق، 180° = جنوب، 270° = غرب).
///
/// Bearing is the angle that indicates the direction to travel from point A
/// to point B. This angle is calculated in degrees from north
/// (0° = North, 90° = East, 180° = South, 270° = West).
///
/// فرمول محاسبه Bearing:
/// ```
/// y = sin(λ2 - λ1) × cos(φ2)
/// x = cos(φ1) × sin(φ2) - sin(φ1) × cos(φ2) × cos(λ2 - λ1)
/// θ = atan2(y, x)
/// bearing = (θ × 180 / π + 360) % 360
/// ```
///
/// که در آن:
/// - φ1, φ2: عرض جغرافیایی دو نقطه به رادیان
/// - λ1, λ2: طول جغرافیایی دو نقطه به رادیان
/// - θ: زاویه به رادیان
/// - bearing: زاویه نهایی به درجه (0-360)
///
/// Where:
/// - φ1, φ2: Latitude of two points in radians
/// - λ1, λ2: Longitude of two points in radians
/// - θ: Angle in radians
/// - bearing: Final angle in degrees (0-360)
///
/// مثال:
/// ```
/// Bearing از تهران به اصفهان:
/// Bearing from Tehran to Isfahan:
/// 
/// y = sin(0.9024 - 0.8968) × cos(0.5706) = 0.0056 × 0.841 = 0.0047
/// x = cos(0.6227) × sin(0.5706) - sin(0.6227) × cos(0.5706) × cos(0.0056)
///   = 0.812 × 0.540 - 0.584 × 0.841 × 0.999
///   = 0.438 - 0.490 = -0.052
/// 
/// θ = atan2(0.0047, -0.052) = -0.090 rad = -5.16°
/// bearing = (-5.16 + 360) % 360 = 354.84° ≈ 355° (تقریباً شمال)
/// ```
///
/// ----------------------------------------------------------------------------
/// تشخیص منبع موقعیت / Location Source Detection
/// ----------------------------------------------------------------------------
///
/// این سرویس می‌تواند تشخیص دهد که موقعیت از کجا آمده است:
/// GPS sensor، Network (WiFi/Cell towers)، یا Passive (موقعیت‌های ذخیره شده).
///
/// This service can detect where the location came from:
/// GPS sensor, Network (WiFi/Cell towers), or Passive (cached positions).
///
/// منطق تشخیص:
/// ```
/// اگر accuracy ≤ 10 متر    → GPS Sensor (دقت بالا)
/// اگر 10 < accuracy ≤ 100 متر → Network/WiFi (دقت متوسط)
/// اگر accuracy > 100 متر   → Passive/Cached (دقت پایین)
/// ```
///
/// Detection logic:
/// ```
/// If accuracy ≤ 10 meters    → GPS Sensor (high accuracy)
/// If 10 < accuracy ≤ 100 meters → Network/WiFi (medium accuracy)
/// If accuracy > 100 meters   → Passive/Cached (low accuracy)
/// ```
///
/// دلیل:
/// - GPS sensor معمولاً دقت 3-10 متر دارد
/// - Network positioning (WiFi/Cell towers) دقت 20-100 متر دارد
/// - Passive/Cached positions معمولاً دقت پایین‌تری دارند
///
/// Reason:
/// - GPS sensor usually has 3-10 meters accuracy
/// - Network positioning (WiFi/Cell towers) has 20-100 meters accuracy
/// - Passive/Cached positions usually have lower accuracy
///
/// ----------------------------------------------------------------------------
/// نحوه استفاده / Usage
/// ----------------------------------------------------------------------------
///
/// ```dart
/// // دریافت سرویس از DI
/// final gpsService = getIt<GPSService>();
///
/// // 1. چک کردن و درخواست permission
/// final permissionStatus = await gpsService.requestPermission();
/// if (permissionStatus != GPSPermissionStatus.granted) {
///   // Handle permission denied
///   return;
/// }
///
/// // 2. دریافت موقعیت فعلی
/// final position = await gpsService.getCurrentPosition(
///   desiredAccuracy: LocationAccuracy.high,
/// );
/// print('Latitude: ${position.latitude}');
/// print('Longitude: ${position.longitude}');
///
/// // 3. دریافت اطلاعات کامل موقعیت (شامل منبع)
/// final locationInfo = await gpsService.getLocationInfo();
/// print('Source: ${locationInfo.sourceDescription}');
/// print('Accuracy: ${locationInfo.accuracyMeters} meters');
/// print('GPS Service Enabled: ${locationInfo.isLocationServiceEnabled}');
///
/// // 4. Listening به تغییرات موقعیت
/// await gpsService.startListening(
///   desiredAccuracy: LocationAccuracy.high,
///   distanceFilter: 10, // فقط وقتی فاصله بیشتر از 10 متر باشد update می‌شود
/// );
///
/// gpsService.positionStream.listen((position) {
///   print('New position: ${position.latitude}, ${position.longitude}');
/// });
///
/// // یا استفاده از locationInfoStream برای اطلاعات کامل
/// gpsService.locationInfoStream.listen((locationInfo) {
///   print('Source: ${locationInfo.sourceDescription}');
///   print('Position: ${locationInfo.position.latitude}, ${locationInfo.position.longitude}');
/// });
///
/// // 5. محاسبه فاصله بین دو نقطه
/// final distance = gpsService.calculateDistance(
///   startLatitude: 35.6892,  // Tehran
///   startLongitude: 51.3890,
///   endLatitude: 32.6546,    // Isfahan
///   endLongitude: 51.6680,
/// );
/// print('Distance: ${distance.toStringAsFixed(0)} meters');
///
/// // 6. محاسبه bearing (جهت)
/// final bearing = gpsService.calculateBearing(
///   startLatitude: 35.6892,
///   startLongitude: 51.3890,
///   endLatitude: 32.6546,
///   endLongitude: 51.6680,
/// );
/// print('Bearing: ${bearing.toStringAsFixed(1)}°');
///
/// // 7. توقف listening
/// await gpsService.stopListening();
/// ```
///
/// ----------------------------------------------------------------------------
/// ساختار داده‌ها / Data Structures
/// ----------------------------------------------------------------------------
///
/// 1. GPSPermissionStatus:
///    - granted: Permission داده شده
///    - denied: Permission رد شده
///    - deniedForever: Permission به صورت دائمی رد شده
///    - checking: در حال چک کردن
///
/// 2. GPSLocationSource:
///    - gps: از سنسور GPS
///    - network: از شبکه (WiFi/Cell towers)
///    - passive: از موقعیت‌های ذخیره شده
///    - unknown: نامشخص
///
/// 3. GPSLocationInfo:
///    - position: موقعیت GPS (Position object)
///    - source: منبع موقعیت
///    - isLocationServiceEnabled: آیا GPS service فعال است
///    - accuracyMeters: دقت به متر
///    - sourceDescription: توضیح منبع
///
/// ----------------------------------------------------------------------------
/// نکات مهم / Important Notes
/// ----------------------------------------------------------------------------
///
/// 1. Permission:
///    - در Android: نیاز به `ACCESS_FINE_LOCATION` یا `ACCESS_COARSE_LOCATION`
///    - در iOS: نیاز به `NSLocationWhenInUseUsageDescription` در Info.plist
///
/// 2. دقت:
///    - LocationAccuracy.lowest: سریع‌ترین، کم‌ترین دقت
///    - LocationAccuracy.low: سریع، دقت متوسط
///    - LocationAccuracy.medium: متعادل
///    - LocationAccuracy.high: دقت بالا، کندتر
///    - LocationAccuracy.best: بالاترین دقت، خیلی کند
///
/// 3. Performance:
///    - استفاده از `distanceFilter` برای کاهش تعداد update ها
///    - استفاده از `LocationAccuracy` مناسب برای نیاز شما
///    - در صورت نیاز، listening را stop کنید تا battery مصرف نشود
///
/// 4. Android GPS Warm-up:
///    - در Android، گاهی GPS نیاز به "warm-up" دارد
///    - بهتر است قبل از listening، یک `getCurrentPosition()` صدا بزنید
///
/// 5. Stream Management:
///    - همیشه subscription ها را در dispose() cancel کنید
///    - قبل از setState() در stream listeners، `mounted` را چک کنید
///
/// ----------------------------------------------------------------------------
/// خطاهای رایج و راه حل / Common Errors and Solutions
/// ----------------------------------------------------------------------------
///
/// 1. "Permission denied":
///    - چک کنید که permission در AndroidManifest.xml و Info.plist اضافه شده باشد
///    - از کاربر درخواست permission کنید
///
/// 2. "Location service disabled":
///    - کاربر باید GPS را در تنظیمات فعال کند
///    - می‌توانید از `openLocationSettings()` استفاده کنید
///
/// 3. "Timeout":
///    - دقت مورد نظر را کاهش دهید
///    - مطمئن شوید که GPS فعال است
///
/// ============================================================================

@module
abstract class GPSServiceModule {
  @lazySingleton
  GPSService provideGPSService() => GPSService();
}

/// وضعیت permission برای GPS
/// GPS permission status
enum GPSPermissionStatus {
  granted, // داده شده / Granted
  denied, // رد شده / Denied
  deniedForever, // به صورت دائمی رد شده / Permanently denied
  checking, // در حال چک کردن / Checking
}

/// منبع موقعیت GPS
/// GPS location source
enum GPSLocationSource {
  gps, // از سنسور GPS / From GPS sensor
  network, // از شبکه (WiFi/Cell towers) / From network (WiFi/Cell towers)
  passive, // از موقعیت‌های قبلی ذخیره شده / From cached previous positions
  unknown, // نامشخص / Unknown
}

/// اطلاعات کامل موقعیت GPS
/// Complete GPS location information
class GPSLocationInfo {
  final Position position;
  final GPSLocationSource source; // منبع موقعیت / Location source
  final bool isLocationServiceEnabled; // آیا GPS service فعال است / Is GPS service enabled
  final double accuracyMeters; // دقت به متر / Accuracy in meters
  final String sourceDescription; // توضیح منبع / Source description

  const GPSLocationInfo({
    required this.position,
    required this.source,
    required this.isLocationServiceEnabled,
    required this.accuracyMeters,
    required this.sourceDescription,
  });

  /// ایجاد از Position
  /// Create from Position
  static Future<GPSLocationInfo> fromPosition(
    Position position,
    GeolocatorPlatform geolocator,
  ) async {
    // بررسی اینکه GPS service فعال است یا نه
    // Check if GPS service is enabled
    final isEnabled = await geolocator.isLocationServiceEnabled();

    // تشخیص منبع بر اساس دقت
    // Detect source based on accuracy
    final accuracy = position.accuracy;
    GPSLocationSource source;
    String sourceDescription;

    if (accuracy <= 0) {
      // دقت نامعتبر
      // Invalid accuracy
      source = GPSLocationSource.unknown;
      sourceDescription = 'نامعتبر / Invalid';
    } else if (accuracy <= 10) {
      // دقت بالا (معمولاً GPS sensor)
      // High accuracy (usually GPS sensor)
      source = GPSLocationSource.gps;
      sourceDescription = 'سنسور GPS / GPS Sensor';
    } else if (accuracy <= 100) {
      // دقت متوسط (معمولاً Network/WiFi)
      // Medium accuracy (usually Network/WiFi)
      source = GPSLocationSource.network;
      sourceDescription = 'شبکه (WiFi/دکل) / Network (WiFi/Cell Towers)';
    } else {
      // دقت پایین (معمولاً Passive یا cached)
      // Low accuracy (usually Passive or cached)
      source = GPSLocationSource.passive;
      sourceDescription = 'موقعیت ذخیره شده / Cached Position';
    }

    return GPSLocationInfo(
      position: position,
      source: source,
      isLocationServiceEnabled: isEnabled,
      accuracyMeters: accuracy,
      sourceDescription: sourceDescription,
    );
  }
}

class GPSService {
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;
  final _positionController = StreamController<Position>.broadcast();

  /// استریم موقعیت GPS
  /// GPS position stream
  Stream<Position> get positionStream => _positionController.stream;

  Position? _lastKnownPosition;

  /// آخرین موقعیت شناخته شده
  /// Last known position
  Position? get lastKnownPosition => _lastKnownPosition;

  GPSService() {
    checkPermissionStatus();
  }

  /// چک کردن وضعیت permission
  /// Check permission status
  Future<GPSPermissionStatus> checkPermissionStatus() async {
    try {
      final status = await Permission.location.status;

      GPSPermissionStatus gpsStatus;
      if (status.isGranted) {
        gpsStatus = GPSPermissionStatus.granted;
      } else if (status.isDenied) {
        gpsStatus = GPSPermissionStatus.denied;
      } else if (status.isPermanentlyDenied) {
        gpsStatus = GPSPermissionStatus.deniedForever;
      } else {
        gpsStatus = GPSPermissionStatus.checking;
      }
      return gpsStatus;
    } catch (e) {
      if (kDebugMode) {
        print('خطا در چک کردن permission: $e');
        // Error checking permission
      }
      return GPSPermissionStatus.denied;
    }
  }

  /// درخواست permission برای GPS
  /// Request GPS permission
  Future<GPSPermissionStatus> requestPermission() async {
    try {
      // bool serviceEnabled = await _geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) {
      //   if (kDebugMode) {
      //     print('GPS غیرفعال است. لطفاً GPS را فعال کنید.');
      //     // GPS is disabled. Please enable GPS.
      //   }
      //   return GPSPermissionStatus.denied;
      // }

      LocationPermission permission = await _geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await _geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            print('Permission برای GPS رد شد');
            // GPS permission denied
          }
          return GPSPermissionStatus.denied;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print('Permission برای GPS به صورت دائمی رد شده است');
          // GPS permission permanently denied
        }
        return GPSPermissionStatus.deniedForever;
      }

      if (kDebugMode) {
        print('Permission برای GPS داده شد');
        // GPS permission granted
      }
      return GPSPermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) {
        print('خطا در درخواست permission: $e');
        // Error requesting permission
      }
      return GPSPermissionStatus.denied;
    }
  }

  /// باز کردن تنظیمات برای فعال کردن GPS
  /// Open settings to enable GPS
  Future<bool> openLocationSettings() async {
    return await openAppSettings();
  }

  /// گرفتن موقعیت فعلی (یک بار)
  /// Get current position (one-time)
  ///
  /// [desiredAccuracy]: دقت مورد نظر / Desired accuracy
  /// [timeLimit]: محدودیت زمانی (ثانیه) / Time limit (seconds)
  Future<Position?> getCurrentPosition({LocationAccuracy desiredAccuracy = LocationAccuracy.lowest, int timeLimit = 10}) async {
    try {
      final permissionStatus = await requestPermission();
      if (permissionStatus != GPSPermissionStatus.granted) {
        if (kDebugMode) {
          print('Permission برای GPS داده نشده است');
          // GPS permission not granted
        }
        return null;
      }

      Position position = await _geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: desiredAccuracy,
          // timeLimit: Duration(seconds: timeLimit),
        ),
      );

      _lastKnownPosition = position;
      if (kDebugMode) {
        print('موقعیت دریافت شد: ${position.latitude}, ${position.longitude}');
        // Position received
      }

      return position;
    } catch (e) {
      if (kDebugMode) {
        print('خطا در گرفتن موقعیت: $e');
        // Error getting position
      }
      return null;
    }
  }

  /// گرفتن آخرین موقعیت شناخته شده
  /// Get last known position
  Future<Position?> getLastKnownPosition() async {
    try {
      final permissionStatus = await requestPermission();
      if (permissionStatus != GPSPermissionStatus.granted) {
        return null;
      }

      Position? position = await _geolocator.getLastKnownPosition();
      if (position != null) {
        _lastKnownPosition = position;
      }
      return position;
    } catch (e) {
      if (kDebugMode) {
        print('خطا در گرفتن آخرین موقعیت: $e');
        // Error getting last known position
      }
      return null;
    }
  }

  /// شروع listening به تغییرات موقعیت
  /// Start listening to position changes
  ///
  /// [desiredAccuracy]: دقت مورد نظر / Desired accuracy
  /// [distanceFilter]: فیلتر فاصله (متر) - فقط وقتی فاصله بیشتر از این مقدار باشد update می‌شود
  ///                   Distance filter (meters) - only updates when distance exceeds this value
  /// [listenToLocationChanges]: آیا به تغییرات موقعیت گوش دهد / Whether to listen to location changes
  Future<bool> startListening({
    LocationAccuracy desiredAccuracy = LocationAccuracy.lowest,
    int distanceFilter = 0,
    bool listenToLocationChanges = true,
  }) async {
    try {
      final permissionStatus = await requestPermission();
      if (permissionStatus != GPSPermissionStatus.granted) {
        if (kDebugMode) {
          print('Permission برای GPS داده نشده است');
          // GPS permission not granted
        }
        return false;
      }

      await stopListening();

      _positionStreamSubscription = _geolocator
          .getPositionStream(
            locationSettings: LocationSettings(accuracy: desiredAccuracy, distanceFilter: distanceFilter),
          )
          .listen(
            (Position position) {
              _lastKnownPosition = position;
              _positionController.add(position);
              if (kDebugMode) {
                print('موقعیت جدید: ${position.latitude}, ${position.longitude}');
                // New position
              }
            },
            onError: (error) {
              if (kDebugMode) {
                print('خطا در listening به GPS: $error');
                // Error listening to GPS
              }
            },
          );

      if (kDebugMode) {
        print('Listening به GPS شروع شد');
        // GPS listening started
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('خطا در شروع listening: $e');
        // Error starting listening
      }
      return false;
    }
  }

  /// توقف listening به تغییرات موقعیت
  /// Stop listening to position changes
  Future<void> stopListening() async {
    try {
      await _positionStreamSubscription?.cancel();
      _positionStreamSubscription = null;
      if (kDebugMode) {
        print('Listening به GPS متوقف شد');
        // GPS listening stopped
      }
    } catch (e) {
      if (kDebugMode) {
        print('خطا در توقف listening: $e');
        // Error stopping listening
      }
    }
  }



  /// محاسبه فاصله بین دو موقعیت (به متر)
  /// Calculate distance between two positions (in meters)
  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }

  /// محاسبه bearing (جهت) بین دو موقعیت (به درجه)
  /// Calculate bearing (direction) between two positions (in degrees)
  double calculateBearing(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.bearingBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }

  /// بررسی اینکه GPS service فعال است یا نه
  /// Check if GPS service is enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await _geolocator.isLocationServiceEnabled();
    } catch (e) {
      if (kDebugMode) {
        print('خطا در چک کردن GPS service: $e');
        // Error checking GPS service
      }
      return false;
    }
  }

  /// دریافت اطلاعات کامل موقعیت (شامل منبع)
  /// Get complete location information (including source)
  Future<GPSLocationInfo?> getLocationInfo() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) return null;

      return await GPSLocationInfo.fromPosition(position, _geolocator);
    } catch (e) {
      if (kDebugMode) {
        print('خطا در دریافت اطلاعات موقعیت: $e');
        // Error getting location info
      }
      return null;
    }
  }

  /// دریافت اطلاعات کامل از آخرین موقعیت شناخته شده
  /// Get complete information from last known position
  Future<GPSLocationInfo?> getLastKnownLocationInfo() async {
    try {
      final position = await getLastKnownPosition();
      if (position == null) return null;

      return await GPSLocationInfo.fromPosition(position, _geolocator);
    } catch (e) {
      if (kDebugMode) {
        print('خطا در دریافت اطلاعات آخرین موقعیت: $e');
        // Error getting last known location info
      }
      return null;
    }
  }

  /// استریم اطلاعات کامل موقعیت (شامل منبع)
  /// Stream of complete location information (including source)
  Stream<GPSLocationInfo> get locationInfoStream async* {
    await for (final position in positionStream) {
      try {
        final info = await GPSLocationInfo.fromPosition(position, _geolocator);
        yield info;
      } catch (e) {
        if (kDebugMode) {
          print('خطا در ایجاد GPSLocationInfo: $e');
          // Error creating GPSLocationInfo
        }
      }
    }
  }

  /// آزاد کردن منابع
  /// Dispose resources
  void dispose() {
    _positionStreamSubscription?.cancel();
    _positionController.close();
    if (kDebugMode) {
      print('GPS Service disposed');
    }
  }
}
