import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  Position userLoc = await Geolocator.getCurrentPosition();

  // Add user's coordinates to preferences.
  prefs.setDouble('userLat', userLoc.latitude);
  prefs.setDouble('userLon', userLoc.longitude);
  getAndSetHumanReadable();
  return userLoc;
}

  Future<void> getAndSetHumanReadable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double userLatitude = prefs.getDouble('userLat') ?? 0.0;
      double userLongitude = prefs.getDouble('userLon') ?? 0.0;

      // Check if the latitude and longitude are valid (not 0.0)
      if (userLatitude == 0.0 || userLongitude == 0.0) {
        print("Invalid coordinates.");
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(userLatitude, userLongitude);

      // Log the placemarks data to inspect it
      // print("Placemarks: $placemarks");

      savePlacemarksToPrefs(placemarks); // Adjust index based on placemark data
    } catch (e) {
      // Log the error message
      print("Error in getHumanReadable(): $e");
    }
  }

  // Convert placemarks to a list of Maps for saving in SharedPreferences
  List<Map<String, dynamic>> placemarksToMapList(List<Placemark> placemarks) {
    return placemarks.map((placemark) {
      return {
        'country': placemark.country,
        'street': placemark.street,
        'administrativeArea': placemark.administrativeArea,
        'subAdministrativeArea': placemark.subAdministrativeArea,
        'locality': placemark.locality,
        'postalCode': placemark.postalCode,
        'thoroughfare': placemark.thoroughfare,
      };
    }).toList();
  }

  // Convert a list of Maps back into a list of Placemark objects
  List<Placemark> mapListToPlacemarks(List<dynamic> maps) {
    return maps.map((map) {
      return Placemark(
        name: map['name'],
        locality: map['locality'],
        administrativeArea: map['administrativeArea'],
        country: map['country'],
        postalCode: map['postalCode'],
        subAdministrativeArea: map['subAdministrativeArea'],
        street: map['street'],
        thoroughfare: map['thoroughfare'],
      );
    }).toList();
  }


  // Save placemarks to SharedPreferences
  Future<void> savePlacemarksToPrefs(List<Placemark> placemarks) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> placemarkMaps = placemarksToMapList(placemarks);

    // Convert the list of maps to a JSON string
    String placemarksJson = jsonEncode(placemarkMaps);
    
    await prefs.setString('placemarks', placemarksJson);
    print("Placemarks saved!");
  }

  // Retrieve placemarks from SharedPreferences
  Future<List<Placemark>> getPlacemarksFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    Duration delay = const Duration(milliseconds: 1500);

    for (int i = 0; i <= 10; i++) {
      String? placemarksJson = prefs.getString('placemarks');
      
      if (placemarksJson != null) {
        List<dynamic> placemarkMaps = jsonDecode(placemarksJson);
        return mapListToPlacemarks(placemarkMaps);
      }
      
      // Wait for a bit before retrying
      await Future.delayed(delay);
    }

    print("Failed to retrieve placemarks after 5 retries.");
    return [];
  }

}
