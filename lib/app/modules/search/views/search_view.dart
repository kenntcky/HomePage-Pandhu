// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_pandhu/app/global_widgets/kotak_gempa.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:aplikasi_pandhu/app/modules/permission/controllers/permission_controller.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchPageController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme and color scheme
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      // Use theme background color
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          AppBar(
                // Removed explicit background color, should use AppBarTheme
                // backgroundColor: Color(0xFFF7F7F7),
                title: Column(
                  children: [
                    Row(
                      children: [
                        const Image(
                          image: AssetImage("asset/img/icon/location.png"),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lokasi Anda,",
                              style: TextStyle(
                                // Use onBackground with opacity
                                color: colorScheme.onBackground.withOpacity(0.6),
                                fontSize: 14,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            FutureBuilder<List<Placemark>>(
                              future: PermissionController().getPlacemarksFromPrefs(),
                              builder: (context, snapshot) {
                                // Determine text color based on theme
                                Color textColor = colorScheme.onBackground;
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text(
                                    'Memuat lokasi...',
                                    style: TextStyle(
                                      // Use theme text color
                                      color: textColor,
                                      fontSize: 14,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Gagal memuat lokasi.',
                                    style: TextStyle(
                                      // Use theme text color
                                      color: textColor,
                                      fontSize: 14,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                  final placemark = snapshot.data![0];
                                  return Text(
                                    '${placemark.subAdministrativeArea}, ${placemark.administrativeArea}',
                                    style: TextStyle(
                                      // Use theme text color
                                      color: textColor,
                                      fontSize: 14,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'Lokasi tidak ditemukan.',
                                    style: TextStyle(
                                      // Use theme text color
                                      color: textColor,
                                      fontSize: 14,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  autofocus: true,
                  onSubmitted: (input) => controller.searchEarthquakeData(input),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search, 
                      // Use theme color for icon
                      color: colorScheme.onSurface.withOpacity(0.6)
                    ),
                    hintText: "Cari informasi gempa",
                    // Use theme color for hint text
                    hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                    // Use surface color for TextField background
                    fillColor: colorScheme.surface,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil',
                      style: TextStyle(
                        // Use theme text color
                        color: colorScheme.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.searchResults.isEmpty) {
                return Center(child: Text('Tidak ada data', style: TextStyle(color: colorScheme.onBackground)));
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      var gempa = controller.searchResults[index];
                      return Kotakgempa(
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
                      );
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
