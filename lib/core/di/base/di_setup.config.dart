// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
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
import '../../handler/service/car_slope_service.dart' as _i306;
import '../../handler/service/gps_service_handler.dart' as _i417;
import '../../handler/service/internet_service_handler.dart' as _i59;
import '../../handler/service/motion_service_handler.dart' as _i125;
import '../../handler/service/nfc_service_handler.dart' as _i361;
import '../../handler/service/supabase_auth_service_handler.dart' as _i849;
import '../local/device_info.dart' as _i510;
import '../remote/interceptor/custom_pretty_logger.dart' as _i154;
import '../remote/remote_module.dart' as _i707;
import 'mode_detection.dart' as _i937;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final deviceModule = _$DeviceModule();
  final remoteModule = _$RemoteModule();
  final internetServiceModule = _$InternetServiceModule();
  final authServiceModule = _$AuthServiceModule();
  final gPSServiceModule = _$GPSServiceModule();
  final motionServiceModule = _$MotionServiceModule();
  final nFCServiceModule = _$NFCServiceModule();
  final carSlopeServiceModule = _$CarSlopeServiceModule();
  gh.singleton<_i510.DeviceInfo>(() => deviceModule.provideDeviceInfo());
  gh.singleton<_i937.ModeDetection>(() => _i937.ModeDetection());
  gh.singleton<_i154.CustomPrettyLogger>(() => remoteModule.prettyDioLogger);
  gh.singleton<_i361.Dio>(() => remoteModule.dio);
  gh.lazySingleton<_i59.InternetService>(
    () => internetServiceModule.provideInternetService(),
  );
  gh.lazySingleton<_i849.AuthService>(
    () => authServiceModule.provideAuthService(),
  );
  gh.lazySingleton<_i417.GPSService>(
    () => gPSServiceModule.provideGPSService(),
  );
  gh.lazySingleton<_i125.MotionService>(
    () => motionServiceModule.provideMotionService(),
  );
  gh.lazySingleton<_i361.NFCService>(
    () => nFCServiceModule.provideNFCService(),
  );
  gh.lazySingleton<_i675.IpService>(() => _i675.IpService(gh<_i361.Dio>()));
  gh.lazySingleton<_i306.CarSlopeService>(
    () => carSlopeServiceModule.provideCarSlopeService(
      gh<_i417.GPSService>(),
      gh<_i125.MotionService>(),
    ),
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

class _$DeviceModule extends _i510.DeviceModule {}

class _$RemoteModule extends _i707.RemoteModule {}

class _$InternetServiceModule extends _i59.InternetServiceModule {}

class _$AuthServiceModule extends _i849.AuthServiceModule {}

class _$GPSServiceModule extends _i417.GPSServiceModule {}

class _$MotionServiceModule extends _i125.MotionServiceModule {}

class _$NFCServiceModule extends _i361.NFCServiceModule {}

class _$CarSlopeServiceModule extends _i306.CarSlopeServiceModule {}
