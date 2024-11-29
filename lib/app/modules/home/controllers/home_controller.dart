import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../database.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> gempaList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> gempaNearestList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final db = DatabaseHelper();
      gempaList.value = await db.getAllGempa();
      gempaNearestList.value = await db.getAllGempaNearest();
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      isLoading.value = false;
    }
  }

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

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      final db = DatabaseHelper();
      gempaList.value = await db.getAllGempa();
      gempaNearestList.value = await db.getAllGempaNearest();
    } catch (e) {
      print('Error refreshing data: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
