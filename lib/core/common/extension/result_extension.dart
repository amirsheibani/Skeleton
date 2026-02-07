import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:skeleton/core/common/extension/network_exceptions.dart';
import 'package:skeleton/core/handler/base/result.dart';


extension ErrorApiResultExtension on Object {
  Result<E> toResult<E>(StackTrace? stackTrace) {
    String str = 'unKnow error';
    String? status;
    if (this is PlatformException) {
      str = (this as PlatformException).code;
    } else if (this is DioException) {
      status = (this as DioException).response?.statusCode.toString();
      final error = Exceptions.getException(this, stackTrace);
      str = Exceptions.getErrorMessage(error);
    }else if (this is StateError) {
      str = toString();
    }else {
      str = stackTrace.toString();
    }
    return Failure<E>(message: str, meta: status);
  }
}

// extension SuccessApiResultExtension on BaseSingleResponse {
//   Result<E> toResult<E,M>() {
//     final result = Success<E>(data: data, message: message,meta: meta);
//     return result;
//   }
// }

