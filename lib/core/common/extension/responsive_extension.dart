import 'package:flutter/material.dart';


extension Responsive on BuildContext {
  T responsive<T>({required T defaultValue, T? sm, T? md, T? lg, T? xl}) {
    final w = MediaQuery.of(this).size.width;
    return w >= 1280
        ? (xl ?? lg ?? md ?? sm ?? defaultValue)
        : w >= 1024
            ? (lg ?? md ?? sm ?? defaultValue)
            : w >= 768
                ? (md ?? sm ?? defaultValue)
                : w >= 640
                    ? (sm ?? defaultValue)
                    : defaultValue;
  }
}
