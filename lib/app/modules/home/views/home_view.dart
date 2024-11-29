import 'package:aplikasi_pandhu/app/global_widgets/bottom_bar.dart';
import 'package:aplikasi_pandhu/app/modules/home/local_widgets/artikel.dart';
import 'package:aplikasi_pandhu/app/global_widgets/kotakgempa.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:aplikasi_pandhu/app/modules/permission/controllers/permission_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => controller.refreshData(),
            child: ListView(
              children: [
                GestureDetector(
                  onTap: () {
                     Get.toNamed(Routes.GANTILOK_EDITLOK);
                   },
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Color(0xFFF7F7F7),
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Image(
                              image: AssetImage("asset/img/icon/location.png"),
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
                                SizedBox(height: 4),
                                // Use FutureBuilder to fetch and display the location asynchronously
                                FutureBuilder<List<Placemark>>(
                                  future: PermissionController().getPlacemarksFromPrefs(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text(
                                        'Memuat lokasi...',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
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
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else {
                                      return Text(
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
                Column(children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        Get.toNamed(Routes.SEARCH);
                      },
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
                          borderSide:
                              BorderSide(width: 0, style: BorderStyle.none),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: 382,
                      height: 201,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF6643C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x99F6643C),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                  'Gempa Sedang Terjadi',
                                  style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    width: 210,
                                    child: Text(
                                      'Hati-hati gempa sedang terjadi di wilayah Kota Semarang. Berpotensi tsunami dari pantai Marina.',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFFFBC1B1),
                                        fontSize: 14,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Selengkapnya',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: AspectRatio(
                              aspectRatio: 1, // This maintains a square aspect ratio for the image
                              child: Image.asset(
                                "asset/img/image/gempa.png",
                                fit: BoxFit.contain, // Preserves image proportions and scales to fit
                              ),
                            ),
                          ),
                        ],
                      )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
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
                              child: Text(
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
                        child: Container(
                          height: 230,
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            
                            if (controller.gempaList.isEmpty) {
                              return const Center(
                                child: Text(
                                  'Tidak ada data gempa terkini',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                              );
                            }

                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: controller.gempaList.take(10).map((gempa) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Kotakgempa(
                                    magnitude: gempa['magnitude'] ?? '-',
                                    lokasi: gempa['wilayah'] ?? '-',
                                    jarak: "${gempa['jarak']} km",
                                    jam: gempa['jam'] != null 
                                        ? gempa['jam'].substring(0, 5) + " WIB"
                                        : '-'
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        child: Container(
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
                                        : '-'
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Row(
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
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              height: 290,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Artikel(),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Artikel(),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Artikel()
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 190,
                      decoration: ShapeDecoration(
                        color: Color(0xFF4EB8FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x994FB8FF),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Separates text from image
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
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
                                SizedBox(
                                  height: 18,
                                ),
                                Container(
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
                                    fit: BoxFit.contain, // Keeps the image responsive and proportionate
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 158,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Menemukan Kesalahan \ndi Aplikasi ',
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
                                SizedBox(
                                  height: 15,
                                ),
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
                  )
                ]),
                SizedBox(
                  height: 48,
                ),
                Column(
                  children: [
                    Text(
                      'Powered by',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 16,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("asset/img/logo/logo-google.png"),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset("asset/img/logo/logo-bmkg.png"),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 151,
                )
              ],
            ),
          ),
          BottomBar()
        ],
      ),
    );
  }
}
