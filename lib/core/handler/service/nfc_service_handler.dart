import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:nfc_manager/nfc_manager.dart';

@module
abstract class NFCServiceModule {
  @lazySingleton
  NFCService provideNFCService() => NFCService();
}

class NFCService {
  NfcManager nfcManager = NfcManager.instance;

  late StreamSubscription _subscription;
  final _controller = StreamController<(NfcAvailability,NfcTag)>.broadcast();

  Stream<(NfcAvailability,NfcTag)> get internetStatus => _controller.stream;

  NFCService() {
    nfcManager.checkAvailability().then((value){
      nfcManager.startSession(onDiscovered: (tag) {
        _controller.add((value,tag));
        nfcManager.stopSession();
      }, pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693, NfcPollingOption.iso18092});

    });

  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
