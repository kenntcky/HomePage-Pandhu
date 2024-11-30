import 'package:aplikasi_pandhu/app/global_widgets/nav_bar.dart';
import 'package:aplikasi_pandhu/app/modules/home/local_widgets/alert_gempa/alert_gempa.dart';
import 'package:aplikasi_pandhu/app/modules/home/local_widgets/artikel.dart';
import 'package:aplikasi_pandhu/app/global_widgets/kotak_gempa.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:aplikasi_pandhu/app/modules/permission/controllers/permission_controller.dart';
import '../../../../database.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: Stack(
        children: [
          ListView(
            children: [
              // App Bar Section
              Container(
                height: 78,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "asset/img/icon/location.png",
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lokasi Anda',
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 12,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w400,
                                ),
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
              ),
              
              // Main Content
              Column(children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    onTap: () {
                      Get.toNamed(Routes.SEARCH);
                    },
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
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
                        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                const AlertGempa(),
                const SizedBox(height: 20),

                // Gempa Terkini Section
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Gempa Terkini',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.RIWAYAT);
                            },
                            child: const Text(
                              'Lebih Detail',
                              style: TextStyle(
                                color: Color(0xFF3BABF6),
                                fontSize: 14,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                                height: 0.11,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                      child: SizedBox(
                        height: 230,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: DatabaseHelper().getAllGempa(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('Gagal memuat data'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('Tidak ada data'));
                            }

                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.take(10).map((gempa) {
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
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Gempa Sekitar Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        'Gempa Sekitar Anda 🚨',
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                  child: SizedBox(
                    height: 230,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (controller.gempaNearestList.isEmpty) {
                        return const Center(
                          child: Text(
                            'Tidak ada data gempa terdekat',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        );
                      }

                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: controller.gempaNearestList.take(10).map((gempa) {
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
                ),

                // Artikel Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Artikel 📑',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 290,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            Artikel(),
                            SizedBox(width: 12),
                            Artikel(),
                            SizedBox(width: 12),
                            Artikel()
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Information Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 190,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF4EB8FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x994FB8FF),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Informasi Bantuan Gempa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 18),
                              SizedBox(
                                width: 210,
                                child: Text(
                                  'Hubungi BMKG atau BPBD kota Anda untuk mendapatkan bantuan dan informasi yang lebih terperinci',
                                  style: TextStyle(
                                    color: Color(0xFFB9E3FF),
                                    fontSize: 14,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.asset(
                                  "asset/img/image/bell.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Contact Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 158,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Menemukan Kesalahan \ndi Aplikasi ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Pandhu?',
                                      style: TextStyle(
                                        color: Color(0xFFF6643C),
                                        fontSize: 20,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Hubungi tim kami melalui ',
                                      style: TextStyle(
                                        color: Color(0xFF636363),
                                        fontSize: 14,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'email \n',
                                      style: TextStyle(
                                        color: Color(0xFF636363),
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'sipanduofficial@gmail.com',
                                      style: TextStyle(
                                        color: Color(0xFF636363),
                                        fontSize: 14,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Image.asset("asset/img/image/checklist.png"),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Footer
                Column(
                  children: [
                    const Text(
                      'Powered by',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 16,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("asset/img/logo/logo-google.png"),
                        const SizedBox(width: 20),
                        Image.asset("asset/img/logo/logo-bmkg.png"),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 151),
              ]),
            ],
          ),
          const Navbar()
        ],
      ),
    );
  }
}
