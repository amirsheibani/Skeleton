import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skeleton/generated/l10n.dart';

base class Exceptions{
  static Exceptions getException(dynamic error, StackTrace? stackTrace) {
    late Exceptions exceptions;
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          exceptions = ConnectionError();
          break;
        case DioExceptionType.cancel:
          exceptions = RequestCancelled();
          break;
        case DioExceptionType.connectionTimeout:
          exceptions = RequestTimeout();
          break;
        case DioExceptionType.unknown:
          exceptions = NoInternetConnection();
          break;
        case DioExceptionType.receiveTimeout:
          exceptions = SendTimeout();
          break;
        case DioExceptionType.sendTimeout:
          exceptions = SendTimeout();
          break;
        case DioExceptionType.badCertificate:
          exceptions = BadCertificate();
          break;
        case DioExceptionType.badResponse:
          switch (error.response?.statusCode) {
            case 400:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = UnauthorisedRequest(message: serverMessage);
              break;
            case 401:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = UnauthorisedRequest(message: serverMessage);
              break;
            case 403:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = UnauthorisedRequest(message: serverMessage);
              break;
            case 404:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];

              exceptions = NotFound(message: serverMessage);
              break;
            case 405:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = MethodNotAllowed(message: serverMessage);
              break;
            case 409:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = Conflict(message: serverMessage);
              break;
            case 408:
              exceptions = RequestTimeout();
              break;
            case 422:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] ?? error.response?.data['otp_code'] : jsonDecode(error.response?.data)['message'] ?? jsonDecode(error.response?.data)['otp_code'];
              exceptions = UnauthorisedRequest(message: serverMessage);
              break;
            case 425:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = TooEarlyRequests(message: serverMessage);
              break;
            case 426:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = UpgradeRequired(message: serverMessage);
              break;
            case 429:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = TooManyRequests(message: serverMessage);
              break;
            case 452:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = UnauthorisedRequest(message: serverMessage);
              break;
            case 500:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = InternalServerError(message: serverMessage);
              break;
            case 502:
              final String? serverMessage = (error.response?.data is Map) ? error.response?.data['message'] : jsonDecode(error.response?.data)['message'];
              exceptions = InternalServerError(message: serverMessage);
              break;
            case 503:
              exceptions = ServiceUnavailable();
              break;
            default:
              final responseCode = error.response?.statusCode;
              exceptions = DefaultError(message: 'Received invalid status code: $responseCode');
          }
          break;
      }
    }
    else if (error is SocketException) {
      exceptions = NoInternetConnection();
    } else if (error is FormatException) {
      exceptions = FormatException();
    } else {
      exceptions = UnableToProcess(error.toString(), stackTrace: stackTrace);
    }
    return exceptions;
  }
  static String getErrorMessage(Exceptions exceptions) {
    var errorMessage = '';
    switch(exceptions){
      case NotImplemented():
       errorMessage = S.current.not_implemented;
      case RequestCancelled():
        errorMessage = S.current.request_cancelled;
      case InternalServerError():
        errorMessage = exceptions.message ?? S.current.internal_server_error;
      case NotFound():
        errorMessage = S.current.not_found;
      case ServiceUnavailable():
        errorMessage = S.current.service_unavailable;
      case MethodNotAllowed():
        errorMessage = exceptions.message ?? S.current.method_not_allowed;
      case BadRequest():
        errorMessage = exceptions.message ?? S.current.bad_request;
      case UnauthorisedRequest():
        errorMessage = exceptions.message ?? S.current.unauthorised_request;
      case UnexpectedError():
        errorMessage = S.current.unexpected_error_occurred;
      case RequestTimeout():
        errorMessage = S.current.connection_request_timeout;
      case NoInternetConnection():
        errorMessage = S.current.no_internet_connection;
      case Conflict():
        errorMessage = S.current.error_due_to_a_conflict(exceptions.message ?? '');
      case SendTimeout():
        errorMessage = S.current.send_timeout_in_connection_with_api_server;
      case UnableToProcess():
        errorMessage = S.current.unable_to_process_the_data(exceptions.stackTrace.toString());
      case DefaultError():
        errorMessage = exceptions.message ?? '-';
      case FormatException():
        errorMessage = S.current.unexpected_error_occurred;
      case NotAcceptable():
        errorMessage = S.current.not_acceptable;
      case ForceUpdateError():
        errorMessage = exceptions.message ?? S.current.need_force_app_update;
      case BadCertificate():
        errorMessage = S.current.bad_certificate;
      case ConnectionError():
        errorMessage = S.current.your_connection_is_failed;
      case TooManyRequests():
       errorMessage = exceptions.message ?? '';
      case TooEarlyRequests():
        errorMessage = exceptions.message ?? '';
      case UpgradeRequired():
        errorMessage = exceptions.message ?? '';
    }
    return errorMessage;
  }
}

final class RequestCancelled extends Exceptions{}
final class BadCertificate extends Exceptions{}
final class ConnectionError extends Exceptions{}
final class UnauthorisedRequest extends Exceptions{
  final String? message;
  UnauthorisedRequest({this.message});
}
final class BadRequest extends Exceptions{
  final String? message;
  BadRequest({this.message});
}
final class NotFound extends Exceptions{
  final String? message;
  NotFound({this.message});
}
final class MethodNotAllowed extends Exceptions{
  final String? message;
  MethodNotAllowed({this.message});
}
final class NotAcceptable extends Exceptions{}
final class RequestTimeout extends Exceptions{}
final class SendTimeout extends Exceptions{}
final class Conflict extends Exceptions{
  final String? message;
  Conflict({this.message});
}
final class InternalServerError extends Exceptions{
  final String? message;
  InternalServerError({this.message});
}
final class UpgradeRequired extends Exceptions{
  final String? message;
  UpgradeRequired({this.message});
}
final class NotImplemented extends Exceptions{}
final class ServiceUnavailable extends Exceptions{}
final class NoInternetConnection extends Exceptions{}
final class FormatException extends Exceptions{}
final class UnableToProcess extends Exceptions{
  final String? message;
  final StackTrace? stackTrace;
  UnableToProcess(this.message, {this.stackTrace});
}
final class DefaultError extends Exceptions{
  final String? message;
  DefaultError({this.message});
}
final class ForceUpdateError extends Exceptions{
  final String? message;
  ForceUpdateError({this.message});
}
final class UnexpectedError extends Exceptions{}
final class TooManyRequests extends Exceptions{
  final String? message;
  TooManyRequests({this.message});
}
final class TooEarlyRequests extends Exceptions{
  final String? message;
  TooEarlyRequests({this.message});
}



