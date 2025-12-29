import 'package:flutter/material.dart';
import 'package:skeleton/core/theme/app_theme.dart';

extension ContextExtension on BuildContext {
  T themeDetection<T> ({required T darkAction, required T lightAction}){

    return darkAction;
  }
}