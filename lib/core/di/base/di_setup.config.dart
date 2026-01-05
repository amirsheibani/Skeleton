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

import '../../handler/service/motion_service_handler.dart' as _i843;
import '../../handler/service/gps_service_handler.dart' as _i417;
import '../../handler/service/internet_service_handler.dart' as _i59;
import '../../handler/service/nfc_service_handler.dart' as _i361;
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
  final internetServiceModule = _$InternetServiceModule();
  final motionServiceModule = _$MotionServiceModule();
  final gPSServiceModule = _$GPSServiceModule();
  final nFCServiceModule = _$NFCServiceModule();
  final deviceModule = _$DeviceModule();
  final remoteModule = _$RemoteModule();
  gh.singleton<_i59.InternetService>(
    () => internetServiceModule.provideInternetService(),
  );
  gh.singleton<_i843.MotionService>(
    () => motionServiceModule.provideMotionService(),
  );
  gh.singleton<_i417.GPSService>(() => gPSServiceModule.provideGPSService());
  gh.singleton<_i361.NFCService>(() => nFCServiceModule.provideNFCService());
  gh.singleton<_i510.DeviceInfo>(() => deviceModule.provideDeviceInfo());
  gh.singleton<_i937.ModeDetection>(() => _i937.ModeDetection());
  gh.singleton<_i154.CustomPrettyLogger>(() => remoteModule.prettyDioLogger);
  gh.singleton<_i361.Dio>(() => remoteModule.dio);
  return getIt;
}

class _$InternetServiceModule extends _i59.InternetServiceModule {}

class _$MotionServiceModule extends _i843.MotionServiceModule {}

class _$GPSServiceModule extends _i417.GPSServiceModule {}

class _$NFCServiceModule extends _i361.NFCServiceModule {}

class _$DeviceModule extends _i510.DeviceModule {}

class _$RemoteModule extends _i707.RemoteModule {}
