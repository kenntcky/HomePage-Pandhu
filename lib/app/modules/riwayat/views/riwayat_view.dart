// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_pandhu/app/global_widgets/nav_bar.dart';
import 'package:aplikasi_pandhu/app/global_widgets/kotak_gempa.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});
  @override
  Widget build(BuildContext context) {
    // Get theme and color scheme
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      // Use theme background color
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => controller.refreshData(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 39, 11, 16),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Gempa Telah Terjadi 🔍',
                          style: TextStyle(
                            color: colorScheme.onBackground,
                            fontSize: 20,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => controller.isOnline.value 
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.wifi_off, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Mode Offline - Menampilkan data lokal',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                      )
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (controller.gempaList.isEmpty) {
                        return Center(child: Text('Tidak ada data', style: TextStyle(color: colorScheme.onBackground)));
                      }

                      return GridView(
                        scrollDirection: Axis.vertical,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                              dirasakan: gempa['dirasakan'] ?? '-'
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
