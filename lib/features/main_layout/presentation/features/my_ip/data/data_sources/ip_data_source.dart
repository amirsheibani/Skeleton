
import 'package:core_framework/core_framework.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/data/models/ip_model.dart';


abstract class IpDataSource {

  Future<BaseSingleResponse<IpModel>> getIp();

}
