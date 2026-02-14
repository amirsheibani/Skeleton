
import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';
import 'package:geolocator/geolocator.dart';

base class GPSState {
  const GPSState();
}

final class GPSInit extends GPSState{
  const GPSInit();
}
final class GPSLoading extends GPSState{

  const GPSLoading();
}
final class GPSSuccess extends GPSState{

  final Position? position;
  final GPSPermissionStatus? gpsPermissionStatus;
  final bool? isListening;
  final GPSLocationInfo? locationInfo; // اطلاعات کامل موقعیت / Complete location information
  const GPSSuccess({this.position,this.gpsPermissionStatus, this.isListening, this.locationInfo});
}
final class GPSFailed extends GPSState{
  final String message;
  const GPSFailed(this.message);
}