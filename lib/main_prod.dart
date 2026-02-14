import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framework_base/packages/framework_core/lib/core_framework.dart';
import 'package:skeleton/app/app.dart';
import 'package:skeleton/bootstrap.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  environment = ProdEnvironment(
    baseUrl: '',
    apiVersion: 'v1',
    mapToken:  String.fromEnvironment('MAPBOX_TOKEN'),
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
