import 'package:skeleton/core/handler/base/result.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/domain/entities/ip_entity.dart';

abstract class IpRepository {
  Future<Result<IpEntity>> getIp();
}
