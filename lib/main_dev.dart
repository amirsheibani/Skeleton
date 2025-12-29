import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeleton/app.dart';
import 'package:skeleton/bootstrap.dart';
import 'package:skeleton/core/env/environment.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  environment = DevEnvironment(
    baseUrl: 'https://api.myip.com',
    apiVersion:'',
    mapToken: 'pk.eyJ1IjoiZHJlYWRlbHVzIiwiYSI6ImNrbzB4cXN0MjBrOTUybnA0bnltZTdtc2gifQ.wPSD6ScnaBT1sm9ii5bYFw',
    appId: 'SKELETON',
    showRuntimeLog: true,
    showChucker: true,
    showPrettyLog: true,
  );

  await appConfiguration();
  runApp(
    const Banner(
      message: 'Dev ',
      location: BannerLocation.bottomStart,
      layoutDirection: TextDirection.ltr,
      textDirection: TextDirection.ltr,
      textStyle: TextStyle(color: Color(0xFFFFFFFF)),
      color: Color(0xFFFF5151),
      child: App(),
    ),
  );
}
