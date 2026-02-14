import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framework_base/packages/framework_core/lib/core_framework.dart';
import 'package:skeleton/core/di/base/di_setup.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/domain/entities/ip_entity.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/domain/use_cases/my_ip_use_case.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/presentation/manager/my_ip_state.dart';

class MyIpNotifier extends StateNotifier<MyIpState> {
  late MyIpUseCase _myIpUseCase;

  MyIpNotifier() : super(const MyIpInit()) {
    _myIpUseCase = getIt<MyIpUseCase>();
  }

  Future<void> getMyIpAddress() async {
    state = const MyIpLoading();
    final result = await _myIpUseCase.call();
    switch (result) {
      case Success<IpEntity>(:final data):
        state = MyIpSuccess(data: data);
      case Failure<IpEntity>(message: final msg):
        state = MyIpFailed(msg);
    }
  }

}

