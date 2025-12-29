import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _subscription;

  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get internetStatus => _controller.stream;

  Future<void> initialize() async {
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {
      final hasInternet = await InternetConnectionChecker().hasConnection;
      _controller.add(hasInternet);
    });

    // چک اولیه
    final hasInternet = await InternetConnectionChecker().hasConnection;
    _controller.add(hasInternet);
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}

enum InternetStatus {
  connected, // اینترنت + پینگ OK
  noPing, // شبکه هست ولی پینگ نداریم
  disconnected, // کلاً شبکه قطع
}

class InternetMonitor {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _subscription;

  final _controller = StreamController<InternetStatus>.broadcast();

  Stream<InternetStatus> get statusStream => _controller.stream;

  // final InternetConnectionChecker _checker = InternetConnectionChecker.createInstance(checkTimeout: const Duration(seconds: 3), checkInterval: const Duration(seconds: 5));

  final checker = InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 3),
    checkInterval: const Duration(seconds: 5),
    addresses: [
      AddressCheckOptions(
        address: InternetAddress('1.1.1.1',type: InternetAddressType.IPv4),
        timeout: const Duration(seconds: 3),
      ),
      AddressCheckOptions(
        address: InternetAddress('8.8.8.8',type: InternetAddressType.IPv4),
        timeout: const Duration(seconds: 3),
      ),
    ],
  );

  Future<void> start() async {
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        _controller.add(InternetStatus.disconnected);
        return;
      }

      final hasInternet = await checker.hasConnection;
      if (hasInternet) {
        _controller.add(InternetStatus.connected);
      } else {
        _controller.add(InternetStatus.noPing);
      }
    });

    // چک اولیه
    final hasInternet = await checker.hasConnection;
    _controller.add(hasInternet ? InternetStatus.connected : InternetStatus.noPing);
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
