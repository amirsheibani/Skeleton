import 'dart:developer' as dev;
import 'dart:io';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:framework_base/packages/framework_core/lib/core_framework.dart';
import 'package:framework_base/packages/framework_utils/lib/utils_framework.dart';
import 'package:injectable/injectable.dart';
import 'package:skeleton/bootstrap.dart';
import 'package:skeleton/core/di/remote/interceptor/token_interceptor.dart';

@module
abstract class RemoteModule {
  @singleton
  TokenInterceptor get _tokenInterceptor => TokenInterceptor();

  @singleton
  ChuckerDioInterceptor get _chuckerDioInterceptor => ChuckerDioInterceptor();

  @singleton
  CustomPrettyLogger get prettyDioLogger => CustomPrettyLogger(curl: true, requestHeader: true, requestBody: true, responseBody: true, responseHeader: true, error: true, compact: true, maxWidth: 180, logPrint: dev.log);

  @singleton
  Dio get dio => _getDio();

  //final dio = getIt<Dio>(instanceName: "downloadFile");
  @Named("downloadFile")
  @lazySingleton
  Dio get dioDownload => _getDioForDownload();

  //final dio = getIt<Dio>(instanceName: "uploadFile");
  @Named("uploadFile")
  @lazySingleton
  Dio get dioUpload => _getDioForUpload();

  _getDio() {
    var dio = Dio(BaseOptions(baseUrl: environment.url!));

    final securityContext = SecurityContext.defaultContext;
    if(sslCert.isNotEmpty){
      securityContext.setTrustedCertificatesBytes(sslCert.codeUnits);
    }


    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient httpClient = HttpClient(context: securityContext);
      return httpClient;
    };

    dio.interceptors.add(_tokenInterceptor);

    if(environment.showPrettyLog ?? false){
      dio.interceptors.add(prettyDioLogger);
    }
    if(environment.showChucker ?? false){
      dio.interceptors.add(_chuckerDioInterceptor);
    }

    late Duration connectTimeout;
    late Duration receiveTimeout;
    late Duration sendTimeout;

    switch(environment){
      case DevEnvironment():
        connectTimeout = const Duration(seconds: 60);
        receiveTimeout = const Duration(seconds: 60);
        sendTimeout = const Duration(seconds: 60);
      case StageEnvironment():
        connectTimeout = const Duration(seconds: 20);
        receiveTimeout = const Duration(seconds: 20);
        sendTimeout = const Duration(seconds: 20);
      case ProdEnvironment():
        connectTimeout = const Duration(seconds: 20);
        receiveTimeout = const Duration(seconds: 20);
        sendTimeout = const Duration(seconds: 20);
    }

    dio.options.connectTimeout = connectTimeout;
    dio.options.receiveTimeout = receiveTimeout;
    dio.options.sendTimeout = sendTimeout;

    return dio;
  }

  _getDioForDownload() {
    var dio = Dio(BaseOptions(baseUrl: environment.url!));

    final securityContext = SecurityContext.defaultContext;
    if(sslCert.isNotEmpty){
      securityContext.setTrustedCertificatesBytes(sslCert.codeUnits);
    }


    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient httpClient = HttpClient(context: securityContext);
      return httpClient;
    };


    late Duration connectTimeout;
    late Duration receiveTimeout;
    late Duration sendTimeout;

    switch(environment){
      case DevEnvironment():
        connectTimeout = const Duration(seconds: 60);
        receiveTimeout = const Duration(seconds: 60);
        sendTimeout = const Duration(seconds: 60);
      case StageEnvironment():
        connectTimeout = const Duration(seconds: 20);
        receiveTimeout = const Duration(seconds: 20);
        sendTimeout = const Duration(seconds: 20);
      case ProdEnvironment():
        connectTimeout = const Duration(seconds: 20);
        receiveTimeout = const Duration(seconds: 20);
        sendTimeout = const Duration(seconds: 20);
    }

    dio.options.connectTimeout = connectTimeout;
    dio.options.receiveTimeout = receiveTimeout;
    dio.options.sendTimeout = sendTimeout;

    return dio;
  }

  _getDioForUpload() {
    var dio = Dio(BaseOptions(baseUrl: environment.url!));

    final securityContext = SecurityContext.defaultContext;
    if(sslCert.isNotEmpty){
      securityContext.setTrustedCertificatesBytes(sslCert.codeUnits);
    }


    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient httpClient = HttpClient(context: securityContext);
      return httpClient;
    };


    late Duration connectTimeout;
    late Duration receiveTimeout;
    late Duration sendTimeout;

    switch(environment){
      case DevEnvironment():
        connectTimeout = const Duration(seconds: 60);
        receiveTimeout = const Duration(seconds: 60);
        sendTimeout = const Duration(seconds: 60);
      case StageEnvironment():
        connectTimeout = const Duration(seconds: 20);
        receiveTimeout = const Duration(seconds: 20);
        sendTimeout = const Duration(seconds: 20);
      case ProdEnvironment():
        connectTimeout = const Duration(seconds: 20);
        receiveTimeout = const Duration(seconds: 20);
        sendTimeout = const Duration(seconds: 20);
    }

    dio.options.connectTimeout = connectTimeout;
    dio.options.receiveTimeout = receiveTimeout;
    dio.options.sendTimeout = sendTimeout;

    return dio;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
