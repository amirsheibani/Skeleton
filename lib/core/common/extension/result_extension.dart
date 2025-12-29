import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:skeleton/core/common/extension/network_exceptions.dart';
import 'package:skeleton/core/handler/base_response.dart';
import 'package:skeleton/core/handler/result.dart';


extension ErrorApiResultExtension on Object {
  Result toResult<T,M>(StackTrace? stackTrace){
    String str = 'unKnow error';
    String? status;
    if (this is PlatformException) {
      str = (this as PlatformException).code;
    } else if (this is DioException) {
      status = (this as DioException).response?.statusCode.toString();
      final error = Exceptions.getException(this, stackTrace);
      str = Exceptions.getErrorMessage(error);
    } else {
      str = stackTrace.toString();
    }
    return Failure<T,M>(str, status: status);
  }
}

extension SuccessApiResultExtension on BaseResponse {
  Result toResult<T,M>(T data, {String? message, String? status, M? meta}) {
    final apiResult = Success<T,M>(data:data, message: message, status: status,meta: meta);
    return apiResult;
  }
}
