import 'package:framework_base/packages/framework_core/lib/core_framework.dart';
import 'package:injectable/injectable.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/data/data_sources/ip_data_source.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/data/mappers/ip_mapper.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/domain/entities/ip_entity.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/domain/repositories/ip_repository.dart';

@Injectable(as: IpRepository)
class IpRepositoryImpl extends IpRepository {
  final IpDataSource _ipDataSource;

  IpRepositoryImpl(this._ipDataSource);

  @override
  Future<Result<IpEntity>> getIp() async {
    try {
      final result = await _ipDataSource.getIp();
      return Success(data: result.data != null ? IpMapperImpl().entityMapper(result.data!) : null ,message: result.message,meta: result.meta);
    } catch (e, stackTrace) {
      return e.toResult<IpEntity>(stackTrace);
    }
  }
}
