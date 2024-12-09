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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          AppBar(
                backgroundColor: Color(0xFFF7F7F7),
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
                            const Text(
                              "Lokasi Anda,",
                              style: TextStyle(
                                color: Color(0xFF666666),
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
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Text(
                                    'Memuat lokasi...',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text(
                                    'Gagal memuat lokasi.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                  final placemark = snapshot.data![0];
                                  return Text(
                                    '${placemark.subAdministrativeArea}, ${placemark.administrativeArea}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return const Text(
                                    'Lokasi tidak ditemukan.',
                                    style: TextStyle(
                                      color: Colors.black,
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
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Cari informasi gempa",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil',
                      style: TextStyle(
                        color: Colors.black,
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
                return const Center(child: Text('Tidak ada data'));
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
