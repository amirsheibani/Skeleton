import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framework_base/packages/framework_core/lib/core_framework.dart';
import 'package:skeleton/app/app.dart';
import 'package:skeleton/bootstrap.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  environment = DevEnvironment(
    baseUrl: 'https://api.myip.com',
    apiVersion:'',
    mapToken:  String.fromEnvironment('MAPBOX_TOKEN'),
    appId: 'SKELETON',
    showRuntimeLog: true,
    showChucker: true,
    showPrettyLog: true,
    supabaseUrl: 'https://lavtjaupeeehoxrcdxbi.supabase.co',
    supabaseAnonKey: 'sb_publishable_aKD9mHNB8q6WSuVlTM33UA_GGlB_MEx',
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
      child: ProviderScope(child: App()),
    ),
  );
}
