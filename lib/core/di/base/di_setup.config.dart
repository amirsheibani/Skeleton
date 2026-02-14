// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:framework_base/packages/framework_utils/lib/utils_framework.dart'
    as _i131;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../features/main_layout/presentation/features/my_ip/data/data_sources/ip_data_source.dart'
    as _i947;
import '../../../features/main_layout/presentation/features/my_ip/data/data_sources/ip_data_source_impl.dart'
    as _i151;
import '../../../features/main_layout/presentation/features/my_ip/data/repositories/ip_repository_impl.dart'
    as _i182;
import '../../../features/main_layout/presentation/features/my_ip/data/services/ip_service.dart'
    as _i675;
import '../../../features/main_layout/presentation/features/my_ip/domain/repositories/ip_repository.dart'
    as _i18;
import '../../../features/main_layout/presentation/features/my_ip/domain/use_cases/my_ip_use_case.dart'
    as _i212;
import '../remote/remote_module.dart' as _i707;
import 'mode_detection.dart' as _i937;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final remoteModule = _$RemoteModule();
  gh.singleton<_i937.ModeDetection>(() => _i937.ModeDetection());
  gh.singleton<_i131.CustomPrettyLogger>(() => remoteModule.prettyDioLogger);
  gh.singleton<_i361.Dio>(() => remoteModule.dio);
  gh.lazySingleton<_i361.Dio>(
    () => remoteModule.dioUpload,
    instanceName: 'uploadFile',
  );
  gh.lazySingleton<_i675.IpService>(() => _i675.IpService(gh<_i361.Dio>()));
  gh.lazySingleton<_i361.Dio>(
    () => remoteModule.dioDownload,
    instanceName: 'downloadFile',
  );
  gh.factory<_i947.IpDataSource>(
    () => _i151.IpDataSourceImpl(gh<_i675.IpService>()),
  );
  gh.factory<_i18.IpRepository>(
    () => _i182.IpRepositoryImpl(gh<_i947.IpDataSource>()),
  );
  gh.factory<_i212.MyIpUseCase>(
    () => _i212.MyIpUseCase(gh<_i18.IpRepository>()),
  );
  return getIt;
}

class _$RemoteModule extends _i707.RemoteModule {}
