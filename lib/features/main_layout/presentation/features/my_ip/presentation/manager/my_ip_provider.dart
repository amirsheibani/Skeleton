import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/presentation/manager/my_ip_notifier.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/presentation/manager/my_ip_state.dart';

final myIpProvider = StateNotifierProvider<MyIpNotifier, MyIpState>((ref) => MyIpNotifier());