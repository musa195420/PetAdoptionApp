import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'dart:async';

class NetworkService {


  bool isConnected = false;

  late final StreamSubscription<InternetStatus> _subscription;

  init(){
    _subscription = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          isConnected = true;
          //_appStatusBarViewModel.setConnectedToInternet(true);
          break;
        case InternetStatus.disconnected:
          isConnected = false;
         // _appStatusBarViewModel.setConnectedToInternet(false);
          break;
      }
    });
  }

  void dispose() {
    _subscription.cancel();
  }
}
