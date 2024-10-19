import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController


  Future<String> getHumanReadable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double userLatitude = prefs.getDouble('userLatitude') ?? 0.0;
      double userLongitude = prefs.getDouble('userLongitude') ?? 0.0;

      // Check if the latitude and longitude are valid (not 0.0)
      if (userLatitude == 0.0 || userLongitude == 0.0) {
        return "Koordinat tidak valid.";
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(userLatitude, userLongitude);

      // Log the placemarks data to inspect it
      print("Placemarks: $placemarks");

      return "${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}"; // Adjust index based on placemark data
    } catch (e) {
      // Log the error message
      print("Error in getHumanReadable(): $e");
      return "Gagal mengambil lokasi.";
    }
  }

}
