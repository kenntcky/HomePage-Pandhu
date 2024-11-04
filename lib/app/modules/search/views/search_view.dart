import 'package:aplikasi_pandhu/app/global_widgets/kotakgempa.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchPageController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: Column(
        children: [
          AppBar(
            backgroundColor: Color(0xFFF7F7F7),
            title: const Column(
              children: [
                Row(
                  children: [
                    Image(
                      image: AssetImage("asset/img/icon/location.png"),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lokasi Anda,",
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Semarang, Jawa Tengah',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  autofocus: true,
                  onSubmitted: (input) => controller.searchEarthquakeData(input),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Cari informasi gempa",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
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
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.searchResults.isEmpty) {
                return Center(child: Text('Tidak ada data'));
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        jam: gempa['jam'] ?? '-',
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
