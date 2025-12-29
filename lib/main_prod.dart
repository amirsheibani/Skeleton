import 'package:flutter/material.dart';
import 'package:skeleton/app.dart';
import 'package:skeleton/bootstrap.dart';
import 'package:skeleton/core/env/environment.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  environment = ProdEnvironment(
    baseUrl: '',
    apiVersion: 'v1',
    mapToken: 'pk.eyJ1IjoiZHJlYWRlbHVzIiwiYSI6ImNrbzB4cXN0MjBrOTUybnA0bnltZTdtc2gifQ.wPSD6ScnaBT1sm9ii5bYFw',
    appId: 'HAMRAH_BANK_SHAHR',
    showRuntimeLog: false,
    showChucker: false,
    showPrettyLog: false,
  );

  await appConfiguration();
  runApp(const App());
}
