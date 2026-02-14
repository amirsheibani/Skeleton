import 'package:framework_base/packages/framework_core/lib/core_framework.dart';
import 'package:injectable/injectable.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/data/data_sources/ip_data_source.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/data/models/ip_model.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/data/services/ip_service.dart';

@Injectable(as: IpDataSource)
class IpDataSourceImpl extends IpDataSource {
  final IpService _ipService;

  IpDataSourceImpl(this._ipService);




  @override
  Future<BaseSingleResponse<IpModel>> getIp() async {
    final result = await _ipService.getIp();
    final response = BaseSingleResponse<IpModel>.fromJson(result,IpModel.fromJson);
    return response;
  }

}
