import 'package:aplikasi_pandhu/app/global_widgets/kotakgempa.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_controller.dart';
import '../../../../database.dart';

class SearchView extends GetView<SearchPageController> {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: Stack(
        children: [
          ListView(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                title: const Column(
                  children: [
                    Row(
                      children: [
                        Image(
                          image: AssetImage("asset/img/location.png"),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lokasi Anda,",
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Semarang, Jawa Tengah',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Plus Jakarta Sans',
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
              Column(
                children: [
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      TextField(
                        autofocus: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Cari informasi gempa",
                          contentPadding: EdgeInsets.zero,
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 0, style: BorderStyle.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Hasil',
                            style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      FutureBuilder<List<Map<String, dynamic>>>(
                          future: DatabaseHelper().getAllGempa(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator()); // Show loading spinner
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('Gagal ')); // Handle error
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('Tidak ada data')); // Handle empty data
                            } else {
                              List<Map<String, dynamic>> gempaData = snapshot.data!;

                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: gempaData.take(10).map((gempa) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Kotakgempa(
                                      magnitude: gempa['magnitude'] ?? '-',
                                      lokasi: gempa['wilayah'] ?? '-',
                                      jarak: "${gempa['jarak']} km",
                                      jam: gempa['jam'] ?? '-'
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ]
              ),
            ]
          ),
        ],
      ),
    );
  }
}
