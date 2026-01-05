import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

/// سرویس مدیریت GPS و موقعیت‌یابی
/// GPS and location management service
///
/// این سرویس امکان دریافت موقعیت فعلی، listening به تغییرات موقعیت،
/// مدیریت permission و محاسبه فاصله و جهت بین دو نقطه را فراهم می‌کند.
///
/// This service provides functionality for getting current position, listening to
/// position changes, managing permissions, and calculating distance and bearing
/// between two points.

@module
abstract class GPSServiceModule {
  @singleton
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
