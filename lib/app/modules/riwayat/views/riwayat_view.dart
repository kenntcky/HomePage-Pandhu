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
          Align(
            alignment: Alignment.bottomCenter,
            child: Expanded(
              child: Container(
                height: 82,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 68),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.HOME);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              child: Image.asset(
                                "asset/img/icon/home-idle.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              'Beranda',
                              style: TextStyle(
                                color: Color(0xFFF6643C),
                                fontSize: 12,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.RIWAYAT);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              child: Image.asset(
                                "asset/img/icon/clock-onclick.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              'Riwayat',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 12,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                              width: 64,
                              height: 64,
                              decoration: ShapeDecoration(
                                color : Color(0xFFF6643C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  ),
                              ),
                              child: 
                              Container(
                                width: 20,
                                height: 20,
                                child: Image.asset("asset/img/icon/chat.png",
                                
                                )
                              ),
                            ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'SiPandhu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  ),
                  ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}
