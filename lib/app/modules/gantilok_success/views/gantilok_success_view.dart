import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/gantilok_success_controller.dart';
import 'package:geolocator/geolocator.dart';
import '../../permission/controllers/permission_controller.dart';
import '../../../routes/app_pages.dart';

class GantilokSuccessView extends GetView<GantilokSuccessController> {
  const GantilokSuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    final Placemark? placemark = Get.arguments;
    
    // Format the location string
    String locationText = 'Location Unknown';
    if (placemark != null) {
      List<String> locationParts = [
        placemark.locality ?? '',
        placemark.administrativeArea ?? '',
        placemark.country ?? ''
      ].where((part) => part.isNotEmpty).toList();
      
      locationText = locationParts.join(', ');
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(), 
            Column(
              children: [
                Image.asset("./asset/img/image/ceklis.png"),
                Text(
                  locationText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
'Lokasi Anda berhasil diubah',
textAlign: TextAlign.center,
style: TextStyle(
color: Color(0xFF666666),
fontSize: 16,
fontFamily: 'Plus Jakarta Sans',
fontWeight: FontWeight.w400,

),
)
              ],
            ),
            const Spacer(), // Spacer kedua untuk mendorong tombol ke bawah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Go back to try again
                      Get.back();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 52,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFF6643C),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Ulangi',
                          style: TextStyle(
                            color: Color(0xFFF6643C),
                            fontSize: 16,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final permissionController = PermissionController();
                      final prefs = await SharedPreferences.getInstance();
                      
                      try {
                        // Get current location
                        Position position = await Geolocator.getCurrentPosition();
                        
                        // Save the new location
                        await prefs.setDouble('userLat', position.latitude);
                        await prefs.setDouble('userLon', position.longitude);
                        
                        // Update placemarks
                        await permissionController.getAndSetHumanReadable();
                        
                        // Navigate to home and clear the stack
                        Get.offAllNamed(Routes.HOME);
                      } catch (e) {
                        print("Error saving location: $e");
                        // Optionally show an error message
                        Get.snackbar(
                          'Error',
                          'Failed to save location',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 52,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF6643C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Benar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
