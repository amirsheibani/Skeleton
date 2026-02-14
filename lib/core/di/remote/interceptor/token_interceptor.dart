import 'package:dio/dio.dart';
import 'package:framework_base/packages/framework_utils/lib/utils_framework.dart';
import 'package:skeleton/core/di/base/di_setup.dart';


class TokenInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    final deviceInfo = getIt<DeviceInfo>();

    options.headers['X-Device-Name'] = '${deviceInfo.deviceName}';
    options.headers['X-Device-Brand'] = '${deviceInfo.brand}';
    options.headers['X-Version'] = '${deviceInfo.version?.split('-').first}';
    options.headers['X-Platform'] = '${deviceInfo.platformName?.value?.toUpperCase()}';


    options.path = options.path;

    handler.next(options);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    //TODO implement auth token
    return handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      //TODO implement token refresh method or navigation
    }else if(err.response?.statusCode == 452){
      //TODO implement token refresh method or navigation
    }
    return handler.next(err);
  }
}
