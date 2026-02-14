import 'package:framework_base/packages/framework_core/lib/core_framework.dart';
import 'package:injectable/injectable.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/domain/entities/ip_entity.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/domain/repositories/ip_repository.dart';

@injectable
class MyIpUseCase extends BaseUseCaseNoArgs<Result<IpEntity>> {
  final IpRepository _repository;

  MyIpUseCase(this._repository);

  @override
  Future<Result<IpEntity>> call() async {
    final result = await _repository.getIp();
    return result;
  }
}