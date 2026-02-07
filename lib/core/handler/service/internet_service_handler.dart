import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';

/// سرویس مدیریت وضعیت اینترنت
/// Internet connection status management service
///
/// این سرویس تغییرات وضعیت اتصال به اینترنت را ردیابی می‌کند و
/// اطلاعاتی درباره نوع اتصال (WiFi، Mobile Data، Bluetooth و غیره)
/// و وضعیت واقعی دسترسی به اینترنت ارائه می‌دهد.
///
/// This service tracks internet connection status changes and provides
/// information about connection type (WiFi, Mobile Data, Bluetooth, etc.)
/// and actual internet access status.

@module
abstract class InternetServiceModule {
  @lazySingleton
  InternetService provideInternetService() => InternetService();
}

class InternetService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _subscription;

  final _controller = StreamController<(bool,ConnectivityResult)>.broadcast();

  /// استریم وضعیت اینترنت
  /// Internet status stream
  ///
  /// Tuple شامل:
  /// Tuple contains:
  /// - bool: آیا واقعاً به اینترنت دسترسی دارد (true) یا نه (false)
  ///         Whether there is actual internet access (true) or not (false)
  /// - ConnectivityResult: نوع اتصال (WiFi, Mobile, Bluetooth, etc.)
  ///                       Connection type (WiFi, Mobile, Bluetooth, etc.)
  Stream<(bool,ConnectivityResult)> get internetStatus => _controller.stream;


  InternetService(){
    // گوش دادن به تغییرات وضعیت اتصال
    // Listening to connection status changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {
      // چک کردن اینکه آیا واقعاً به اینترنت دسترسی دارد
      // Checking if there is actual internet access
      InternetConnectionChecker().hasConnection.then((value){
        // ارسال وضعیت به stream
        // Sending status to stream
        _controller.add((value,result.last));
      });
    });
  }

  /// آزاد کردن منابع
  /// Dispose resources
  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
