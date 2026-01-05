
import 'package:geolocator/geolocator.dart';
import 'package:skeleton/core/handler/service/gps_service_handler.dart';

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
  const GPSSuccess({this.position,this.gpsPermissionStatus, this.isListening});
}
final class GPSFailed extends GPSState{
  final String message;
  const GPSFailed(this.message);
}