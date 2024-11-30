import 'package:aplikasi_pandhu/app/global_widgets/nav_bar.dart';
import 'package:aplikasi_pandhu/app/global_widgets/kotak_gempa.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => controller.refreshData(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 39, 11, 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Gempa Telah Terjadi 🔍',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (controller.gempaList.isEmpty) {
                        return const Center(child: Text('Tidak ada data'));
                      }

                      return GridView(
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          childAspectRatio: 4/5,
                        ),
                        children: controller.gempaList.take(10).map((gempa) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Kotakgempa(
                              magnitude: gempa['magnitude'] ?? '-',
                              lokasi: gempa['wilayah'] ?? '-',
                              jarak: "${gempa['jarak']} km",
                              jam: gempa['jam'] != null 
                                ? gempa['jam'].substring(0, 5) + " WIB"
                                : '-',
                              tanggal: gempa['tanggal'] ?? '-',
                              coordinates: gempa['coordinates'] ?? '-',
                              lintang: gempa['lintang'] ?? '-',
                              bujur: gempa['bujur'] ?? '-',
                              kedalaman: gempa['kedalaman'] ?? '-',
                              potensi: gempa['potensi'] ?? '-',
                              dirasakan: gempa['dirasakan'] ?? '-',
                              shakemap: gempa['shakemap'],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                  SizedBox(height: 75),
                ],
              ),
            ),
          ),
          Navbar()
        ],
      )
    );
  }
}
