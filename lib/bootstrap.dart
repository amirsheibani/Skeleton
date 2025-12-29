import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeleton/core/di/base/di_setup.dart';
import 'package:skeleton/core/di/local/device_info.dart';
import 'package:skeleton/core/env/environment.dart';
import 'package:skeleton/core/handler/service/internet_service_handler.dart';

late Environment environment;
const platformChannel = MethodChannel('top.amirdeveloper.plugins');
late String sslCert;
late String authToken;

Future<void> appConfiguration() async {
  WidgetsFlutterBinding.ensureInitialized();

  // sslCert = await rootBundle.loadString('asset/certificates/cert.live.pem');
  sslCert = '';

  configureDependencies();

  final deviceInfo = getIt<DeviceInfo>();
  await deviceInfo.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (environment.showChucker ?? false) {
    ChuckerFlutter.showOnRelease = true;
    ChuckerFlutter.showNotification = true;
  }

  await requestNotificationPermission();

  InternetMonitor internetMonitor = InternetMonitor();
  internetMonitor.start();
  internetMonitor.statusStream.listen((data){
    if(data != InternetStatus.connected){
      print('internet failed');
    }else{
      print('internet ok');
    }
  });
}



Future<void> requestNotificationPermission() async {
  if(!kIsWeb){
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
}


