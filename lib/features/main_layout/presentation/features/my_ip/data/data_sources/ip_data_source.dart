
import 'package:framework_base/packages/framework_core/lib/core_framework.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/data/models/ip_model.dart';


abstract class IpDataSource {

  Future<BaseSingleResponse<IpModel>> getIp();

}
