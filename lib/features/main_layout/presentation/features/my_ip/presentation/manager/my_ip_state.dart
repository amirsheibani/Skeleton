
import 'package:skeleton/features/main_layout/presentation/features/my_ip/domain/entities/ip_entity.dart';

base class MyIpState {
  const MyIpState();
}

final class MyIpInit extends MyIpState {
  const MyIpInit();
}

final class MyIpLoading extends MyIpState {
  const MyIpLoading();
}

final class MyIpSuccess extends MyIpState {
  final IpEntity? data;

  const MyIpSuccess({
    this.data,
  });
}

final class MyIpFailed extends MyIpState {
  final String message;
  const MyIpFailed(this.message);
}