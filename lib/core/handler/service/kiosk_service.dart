import 'package:flutter/services.dart';

class KioskService {
  static const _channel = MethodChannel('kiosk_channel');

  static Future<void> start() async {
    await _channel.invokeMethod('startKiosk');
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('stopKiosk');
  }

  static Future<bool> isInKiosk() async {
    return await _channel.invokeMethod('isInKiosk');
  }
}
