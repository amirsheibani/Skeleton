import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InternetServiceModule {
  @singleton
  InternetService provideInternetService() => InternetService();
}

class InternetService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _subscription;

  final _controller = StreamController<(bool,ConnectivityResult)>.broadcast();

  Stream<(bool,ConnectivityResult)> get internetStatus => _controller.stream;


  InternetService(){
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {
      InternetConnectionChecker().hasConnection.then((value){
        _controller.add((value,result.last));
      });
    });
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
