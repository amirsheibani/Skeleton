import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainLayoutNotifier extends StateNotifier<int> {

  MainLayoutNotifier() : super(0);

  Future<void> init() async {
    state = 0;
  }

  Future<void> goto(int index) async {
    state = index;
  }
}

