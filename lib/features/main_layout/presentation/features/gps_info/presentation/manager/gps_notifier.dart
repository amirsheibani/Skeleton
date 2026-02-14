import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';
import 'package:skeleton/core/di/base/di_setup.dart';
import 'package:skeleton/features/main_layout/presentation/features/gps_info/presentation/manager/gps_state.dart';


class GPSNotifier extends StateNotifier<GPSState> {
  late GPSService _gpsService;
  GPSNotifier() : super(const GPSInit()){
    _gpsService = getIt<GPSService>();
  }
  StreamSubscription<GPSLocationInfo>? _subscription;
  GPSPermissionStatus gpsPermissionStatus  = GPSPermissionStatus.denied;

  Future<void> init() async {
    state = GPSLoading();
    gpsPermissionStatus = await _gpsService.requestPermission();
    state = GPSSuccess(position: null,gpsPermissionStatus: gpsPermissionStatus,isListening: false);
    if(gpsPermissionStatus == GPSPermissionStatus.granted){
      final position = await _gpsService.getCurrentPosition();
      final locationInfo = position != null ? await _gpsService.getLocationInfo() : null;
      state = GPSSuccess(
        position: position,
        gpsPermissionStatus: gpsPermissionStatus,
        isListening: false,
        locationInfo: locationInfo,
      );
    }else{
      state = GPSFailed('request Permission failed');
    }
  }

  Future<void> getCurrentPosition() async {
    if(gpsPermissionStatus == GPSPermissionStatus.granted){
      final position = await _gpsService.getCurrentPosition();
      final locationInfo = position != null ? await _gpsService.getLocationInfo() : null;
      state = GPSSuccess(
        position: position,
        gpsPermissionStatus: gpsPermissionStatus,
        isListening: false,
        locationInfo: locationInfo,
      );
    }else{
      state = GPSFailed('request Permission failed');
    }
  }

  Future<void> getLastKnownPosition() async {
    if(gpsPermissionStatus == GPSPermissionStatus.granted){
      final position = await _gpsService.getLastKnownPosition();
      final locationInfo = position != null ? await _gpsService.getLastKnownLocationInfo() : null;
      state = GPSSuccess(
        position: position,
        gpsPermissionStatus: gpsPermissionStatus,
        isListening: false,
        locationInfo: locationInfo,
      );
    }else{
      state = GPSFailed('request Permission failed');
    }
  }

  Future<void> listenChange() async {
    if(gpsPermissionStatus == GPSPermissionStatus.granted){
      _subscription?.cancel();
      await _gpsService.startListening();
      // استفاده از locationInfoStream برای دریافت اطلاعات کامل
      // Use locationInfoStream to get complete information
      _subscription = _gpsService.locationInfoStream.listen((locationInfo) {
        state = GPSSuccess(
          position: locationInfo.position,
          gpsPermissionStatus: gpsPermissionStatus,
          isListening: true,
          locationInfo: locationInfo,
        );
      });
    }else{
      state = GPSFailed('request Permission failed');
    }
  }
  Future<void> stopListen() async {
    if(gpsPermissionStatus == GPSPermissionStatus.granted){
      _subscription?.cancel();
      await _gpsService.stopListening();
      final position = await _gpsService.getLastKnownPosition();
      final locationInfo = position != null ? await _gpsService.getLastKnownLocationInfo() : null;
      state = GPSSuccess(
        position: position,
        gpsPermissionStatus: gpsPermissionStatus,
        isListening: false,
        locationInfo: locationInfo,
      );
    }else{
      state = GPSFailed('request Permission failed');
    }
  }


  @override
  void dispose() {
    _subscription?.cancel();
    _gpsService.dispose();
    super.dispose();
  }

  void reset() {
    state = const GPSInit();
  }

}

