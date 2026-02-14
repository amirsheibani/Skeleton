import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'ip_service.g.dart';

@RestApi()
@lazySingleton
abstract class IpService {
  @factoryMethod
  factory IpService(Dio dio,) = _IpService;

  @GET('/')
  Future<HttpResponse<String>> getIp();

}


