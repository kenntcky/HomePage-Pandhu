import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../../permission/controllers/permission_controller.dart';
import '../controllers/gantilok_editlok_controller.dart';
import '../../gantilok_success/views/gantilok_success_view.dart';
import '../../gantilok_failed/views/gantilok_failed_view.dart';

class GantilokEditlokView extends GetView<GantilokEditlokController> {
  const GantilokEditlokView({super.key});
  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Perizinan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pandhu akan mengakses lokasi Anda untuk menentukan lokasi Anda sekarang dengan akurat dan segala informasi mengenai gempa akan diubah',
                style: TextStyle(
                  color: Color(0xFF49454F),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      "Tidak",
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final permissionController = PermissionController();
                      try {
                        // This will handle location service check and permissions
                        await permissionController.determinePosition();
                        
                        // Get the placemarks after location is updated
                        List<Placemark> placemarks = await permissionController.getPlacemarksFromPrefs();
                        
                        if (placemarks.isEmpty) {
                          // If no placemarks were retrieved, show failed view
                          Navigator.of(context).pop(); // Close the dialog
                          Get.to(() => const GantilokFailedView());
                          return;
                        }
                        
                        // Navigate to success view with location data
                        Navigator.of(context).pop(); // Close the dialog
                        Get.to(() => const GantilokSuccessView(), arguments: placemarks[0]);
                      } catch (e) {
                        print("Error updating location: $e");
                        Navigator.of(context).pop(); // Close the dialog
                        Get.to(() => const GantilokFailedView());
                      }
                    },
                    child: const Text(
                      "Izinkan & Aktifkan",
                      style: TextStyle(
                        color: Color(0xFFF6643C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(), 
            Column(
              children: [
                Image.asset("./asset/img/image/gantilokasi.png"),
                const Text(
                  'Apakah Anda yakin ingin \nmengubah lokasi Anda?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Segala informasi mengenai \ngempa akan diubah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
                          'Tidak',
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
                    onTap: () => _showPermissionDialog(context),
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
                          'Setuju',
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
