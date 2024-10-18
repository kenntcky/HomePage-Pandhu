import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionController extends GetxController {
  late bool serviceEnabled;
  late LocationPermission permission;
  late Position position;

  Future<Position> determinePosition() async {
    
  final prefs = await SharedPreferences.getInstance();
  bool serviceEnabled;
  LocationPermission permission;
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are disabled, prompt the user to turn on location services
    Geolocator.openLocationSettings();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      Get.toNamed(Routes.HOME);
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
  Get.toNamed(Routes.HOME);
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  await prefs.setBool('locationInitialized', true);
  Get.toNamed(Routes.HOME);
  return await Geolocator.getCurrentPosition();
}
}
