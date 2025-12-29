import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_html/js.dart' as js;

enum PlatformName {
  android('Android'),
  iOS('iOS'),
  pwa('PWA');

  final String? value;

  const PlatformName(this.value);
}

@module
abstract class DeviceModule {
  @singleton
  DeviceInfo provideDeviceInfo() => DeviceInfo();
}

class DeviceInfo {
  String? brand;
  String? deviceName;
  String? serialNumber;
  PlatformName? platformName;
  String? version;
  String? buildNumber;
  String? buildSignature;
  late bool haveGoogleService;

  Future<String?> init() async {
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      buildSignature = packageInfo.buildSignature;
      buildNumber = packageInfo.buildNumber;
      if (kIsWeb) {
        final deviceInfo = js.context.callMethod('getDeviceInfo');
        final temp = deviceInfo is String ? deviceInfo.split(':') : <String>[];
        serialNumber = temp.isNotEmpty ? temp[0] : null;
        brand = temp.length >= 2 ? temp[1] : null;
        deviceName = temp.length >= 3 ? temp[2] : null;
        platformName = PlatformName.pwa;
      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo data = await deviceInfoPlugin.androidInfo;
        brand = data.brand;
        deviceName = data.model;
        platformName = PlatformName.android;
      } else if (Platform.isIOS) {
        final IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        brand = data.systemName;
        deviceName = data.model;
        platformName = PlatformName.iOS;
      }
      if(!kIsWeb && Platform.isAndroid){
        final GooglePlayServicesAvailability resultGoogleApi = await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
        switch (resultGoogleApi) {
          case GooglePlayServicesAvailability.success:
            haveGoogleService = true;
            break;
          case GooglePlayServicesAvailability.unknown:
          case GooglePlayServicesAvailability.notAvailableOnPlatform:
          case GooglePlayServicesAvailability.serviceInvalid:
          case GooglePlayServicesAvailability.serviceMissing:
            haveGoogleService =  false;
            break;
          case GooglePlayServicesAvailability.serviceUpdating:
            haveGoogleService =  false;
            break;
          case GooglePlayServicesAvailability.serviceVersionUpdateRequired:
            haveGoogleService =  false;
            break;
          case GooglePlayServicesAvailability.serviceDisabled:
            haveGoogleService =  false;
            break;
        }
      }else{
        haveGoogleService =  false;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
