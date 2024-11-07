import 'package:aplikasi_pandhu/app/global_widgets/bottom_bar.dart';
import 'package:aplikasi_pandhu/app/global_widgets/kotakgempa.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/riwayat_controller.dart';
import '../../../../database.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: Stack(
        children: [
          Padding(
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
                  child: FutureBuilder<List<Map<String, dynamic>>>(
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

                              return GridView(
                                scrollDirection: Axis.vertical,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 0,
                                  childAspectRatio: 4/5,
                                  ),
                                children: gempaData.take(10).map((gempa) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Kotakgempa(
                                      magnitude: gempa['magnitude'] ?? '-',
                                      lokasi: gempa['wilayah'] ?? '-',
                                      jarak: "${gempa['jarak']}",
                                      jam: gempa['jam'] ?? '-'
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                ),
                SizedBox(
                  height: 75,
                ),
              ],
            ),
          ),
          BottomBar()
        ],
      )
    );
  }
}
