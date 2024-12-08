import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityUtils {
  static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      // Double check with actual internet connection test
      return await InternetConnectionChecker().hasConnection;
    } catch (e) {
      print('Error checking internet connection: $e');
      return false;
    }
  }
}
