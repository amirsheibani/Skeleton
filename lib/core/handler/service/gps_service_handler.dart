import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@module
abstract class GPSServiceModule {
  @singleton
  GPSService provideGPSService() => GPSService();
}

enum GPSPermissionStatus { granted, denied, deniedForever, checking }

class GPSService {
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _positionStreamSubscription;
  final _positionController = StreamController<Position>.broadcast();

  Stream<Position> get positionStream => _positionController.stream;

  Position? _lastKnownPosition;

  Position? get lastKnownPosition => _lastKnownPosition;

  GPSService() {
    checkPermissionStatus();
  }

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
      }
      return GPSPermissionStatus.denied;
    }
  }

  Future<GPSPermissionStatus> requestPermission() async {
    try {
      // bool serviceEnabled = await _geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) {
      //   if (kDebugMode) {
      //     print('GPS غیرفعال است. لطفاً GPS را فعال کنید.');
      //   }
      //   return GPSPermissionStatus.denied;
      // }

      LocationPermission permission = await _geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await _geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            print('Permission برای GPS رد شد');
          }
          return GPSPermissionStatus.denied;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print('Permission برای GPS به صورت دائمی رد شده است');
        }
        return GPSPermissionStatus.deniedForever;
      }

      if (kDebugMode) {
        print('Permission برای GPS داده شد');
      }
      return GPSPermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) {
        print('خطا در درخواست permission: $e');
      }
      return GPSPermissionStatus.denied;
    }
  }

  Future<bool> openLocationSettings() async {
    return await openAppSettings();
  }

  Future<Position?> getCurrentPosition({LocationAccuracy desiredAccuracy = LocationAccuracy.lowest, int timeLimit = 10}) async {
    try {
      final permissionStatus = await requestPermission();
      if (permissionStatus != GPSPermissionStatus.granted) {
        if (kDebugMode) {
          print('Permission برای GPS داده نشده است');
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
      }

      return position;
    } catch (e) {
      if (kDebugMode) {
        print('خطا در گرفتن موقعیت: $e');
      }
      return null;
    }
  }

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
      }
      return null;
    }
  }

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
              }
            },
            onError: (error) {
              if (kDebugMode) {
                print('خطا در listening به GPS: $error');
              }
            },
          );

      if (kDebugMode) {
        print('Listening به GPS شروع شد');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('خطا در شروع listening: $e');
      }
      return false;
    }
  }

  Future<void> stopListening() async {
    try {
      await _positionStreamSubscription?.cancel();
      _positionStreamSubscription = null;
      if (kDebugMode) {
        print('Listening به GPS متوقف شد');
      }
    } catch (e) {
      if (kDebugMode) {
        print('خطا در توقف listening: $e');
      }
    }
  }



  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }

  double calculateBearing(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    return Geolocator.bearingBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }

  void dispose() {
    _positionStreamSubscription?.cancel();
    _positionController.close();
    if (kDebugMode) {
      print('GPS Service disposed');
    }
  }
}
