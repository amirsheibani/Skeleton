
import 'dart:convert' as convert;
import 'package:retrofit/retrofit.dart';

base class BaseResponse {
  final String? status;
  final String? message;

  BaseResponse({this.status, this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

final class BaseListResponse<T> extends BaseResponse {
  List<T>? data;

  BaseListResponse({
    super.message,
    super.status,
    this.data,
  });

  factory BaseListResponse.fromJson(HttpResponse<String> response, Function(Map<String, dynamic>) create) {
    final data = <T>[];
    Map<String, dynamic> json = convert.json.decode(response.data);
    json['data'].forEach((v) {
      data.add(create(v));
    });
    return BaseListResponse<T>(status: json['status'], message: json['message'], data: data);
  }
}

final class BaseSingleResponse<T> extends BaseResponse {
  T? data;

  BaseSingleResponse({
    super.message,
    super.status,
    this.data,
  });

  factory BaseSingleResponse.fromJson(HttpResponse<String> response, Function(Map<String, dynamic>) create) {
    Map<String, dynamic> json =  convert.json.decode(response.data);
    return BaseSingleResponse<T>(status: json['status'], message: json['message'], data: json['data'] != null ? create(json['data']) : null);
  }
}

final class BaseSingleResponseWithoutDataJson<T> extends BaseResponse {
  T? data;

  BaseSingleResponseWithoutDataJson({
    super.message,
    super.status,
    this.data,
  });

  factory BaseSingleResponseWithoutDataJson.fromJson(Map<String, dynamic> json, Function(dynamic) create) {
    return BaseSingleResponseWithoutDataJson<T>(status: json['status'], message: json['message'], data: json['data']);
  }
}


final class BaseListResponseWithPages<T,M> extends BaseListResponse<T> {
  M? meta;
  dynamic any;

  BaseListResponseWithPages({
    this.meta,
    this.any,
    super.message,
    super.status,
    super.data,
  });

  factory BaseListResponseWithPages.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create,dynamic any) {
    final data = <T>[];
    json['items'].forEach((v) {
      data.add(create(v));
    });
    return BaseListResponseWithPages<T,M>(
      status: json['status'],
      message: json['message'],
      data: data,
      any: any,
    );
  }
}
