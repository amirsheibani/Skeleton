import 'package:skeleton/features/main_layout/presentation/features/my_ip/data/models/ip_model.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/domain/entities/ip_entity.dart';


extension OnIpModel on IpModel?{
IpEntity mapper() {
  if(this == null){
    throw StateError('Invalid data ,IpModel is null');
  }
  if(this?.ip != null && this!.ip!.isEmpty){
    throw StateError('Invalid data ,ip is null or empty');
  }
  if(this?.country != null && this!.country!.isEmpty){
    throw StateError('Invalid data ,country is null or empty');
  }
  if(this?.cc != null && this!.cc!.isEmpty){
    throw StateError('Invalid data ,cc is null or empty');
  }

  return IpEntity(this!.ip!,this!.country!,this!.cc!);
}
}


