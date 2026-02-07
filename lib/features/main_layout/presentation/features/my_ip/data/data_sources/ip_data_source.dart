
import 'package:skeleton/core/handler/base/base_response.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/data/models/ip_model.dart';


abstract class IpDataSource {

  Future<BaseSingleResponse<IpModel>> getIp();

}
