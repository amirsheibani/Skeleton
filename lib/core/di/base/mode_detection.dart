import 'dart:async';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:skeleton/bootstrap.dart';

@singleton
class ModeDetection{
  static const platform = platformChannel;
  String _brightness = 'unknown';
  // ValueChanged<String> onChange;
  final StreamController<String> controller = StreamController<String>();
  ModeDetection(){
    platform.setMethodCallHandler(_handleNativeCall);
  }

  Future<void> _handleNativeCall(MethodCall call) async {
    if (call.method == 'brightnessChanged') {
      _brightness = call.arguments as String;
      print('Brightness changed: $_brightness');
      controller.add(_brightness);

    }
  }
  Stream<String> getStream(){
    return controller.stream;
  }
  void close(){
    if(!controller.isClosed){
      controller.close();
    }
  }
}