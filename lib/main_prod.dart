import 'package:core_framework/core_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/app/app.dart';
import 'package:skeleton/bootstrap.dart';

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
    supabaseUrl: 'https://lavtjaupeeehoxrcdxbi.supabase.co',
    supabaseAnonKey: 'sb_publishable_aKD9mHNB8q6WSuVlTM33UA_GGlB_MEx',
  );

  await appConfiguration();
  runApp(ProviderScope(child: App()),);
}
