import 'package:connectivity_plus/connectivity_plus.dart';

/// Checking if connected to internet or not.
Future<bool> checkIsConnectedToInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else if (connectivityResult == ConnectivityResult.ethernet) {
    return true;
  } else if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    return false;
  }
}