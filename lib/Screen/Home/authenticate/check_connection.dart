import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnection {
  Future<String> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return 'mobile';
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return 'wifi';
    } else if (connectivityResult == ConnectivityResult.vpn) {
      return 'vpn';
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return 'ethernet';
    } else if (connectivityResult == ConnectivityResult.none) {
      return 'none';
    }
    return 'not';
  }
}
