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
import 'package:aplikasi_pandhu/app/controllers/theme_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    // Get current theme data
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      // Use theme background color
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => controller.refreshData(),
            child: ListView(
              children: [
                // App Bar Section
                GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.GANTILOK_EDITLOK);
                },
                child: Container(
                    height: 78,
                    decoration: const BoxDecoration(
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
                                  Text(
                                    'Lokasi Anda',
                                    style: TextStyle(
                                      // Use theme color with opacity for secondary text
                                      color: colorScheme.onBackground.withOpacity(0.6),
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
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
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          // Hint text color should also adapt
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        fillColor: colorScheme.surface,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                        ),
                      ),
                    ),
                  ),
                  
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
                            Text(
                              'Gempa Terkini',
                              style: TextStyle(
                                // Use theme color
                                color: colorScheme.onBackground,
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
                                  // Reverted to original blue color
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
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const SizedBox(
                              height: 230,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          
                          if (controller.gempaList.isEmpty) {
                            return SizedBox(
                              height: 230,
                              // Use theme text color
                              child: Center(child: Text('Tidak ada data gempa', style: TextStyle(color: colorScheme.onBackground))),
                            );
                          }

                          return SizedBox(
                            height: 230,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: controller.gempaList.map((gempa) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Kotakgempa(
                                    magnitude: gempa['magnitude'] ?? 'Tidak ada data',
                                    lokasi: gempa['wilayah'] ?? 'Tidak ada data',
                                    jarak: "${gempa['jarak'] ?? '-'} km",
                                    jam: gempa['jam'] != null 
                                        ? gempa['jam'].substring(0, 5) + " WIB"
                                        : 'Tidak ada data',
                                    tanggal: gempa['tanggal'] ?? 'Tidak ada data',
                                    coordinates: gempa['coordinates'] ?? 'Tidak ada data',
                                    lintang: gempa['lintang'] ?? 'Tidak ada data',
                                    bujur: gempa['bujur'] ?? 'Tidak ada data',
                                    kedalaman: gempa['kedalaman'] ?? 'Tidak ada data',
                                    potensi: gempa['potensi'] ?? 'Tidak ada data',
                                    dirasakan: gempa['dirasakan'] ?? 'Tidak ada data'
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
            
                  // Gempa Sekitar Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          'Gempa Sekitar Anda 🚨',
                          style: TextStyle(
                            // Use theme color
                            color: colorScheme.onBackground,
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
                          return Center(
                            child: Text(
                              'Tidak ada data gempa terdekat',
                              style: TextStyle(
                                // Use theme color
                                color: colorScheme.onBackground,
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
                                dirasakan: gempa['dirasakan'] ?? '-'
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
                        Row(
                          children: [
                            Text(
                              'Artikel 📑',
                              style: TextStyle(
                                // Use theme color
                                color: colorScheme.onBackground,
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
                              // Artikel(),
                              // SizedBox(width: 12),
                              // Artikel()
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
                        // Reverted to original hardcoded blue
                        color: const Color(0xFF4EB8FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // Reverted to original hardcoded shadow color
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Informasi Bantuan Gempa',
                                  style: TextStyle(
                                    // Reverted to original hardcoded white
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
                                    'Hubungi BMKG atau BPBD kota Anda untuk mendapatkan informasi terperinci',
                                    style: TextStyle(
                                      // Reverted to original hardcoded light blue
                                      color: const Color(0xFFB9E3FF),
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
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(10)
                      ),
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
                                        text: 'Menemukan Kesalahan \ndi Aplikasi ',
                                        style: TextStyle(
                                          color: colorScheme.onSurface,
                                          fontSize: 20,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Pandhu?',
                                        style: TextStyle(
                                          color: colorScheme.error,
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
                                          color: colorScheme.onSurface.withOpacity(0.6),
                                          fontSize: 14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'email \n',
                                        style: TextStyle(
                                          color: colorScheme.onSurface.withOpacity(0.6),
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'sipanduofficial@gmail.com',
                                        style: TextStyle(
                                          color: colorScheme.onSurface.withOpacity(0.6),
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
                      Text(
                        'Powered by',
                        style: TextStyle(
                          color: colorScheme.onBackground.withOpacity(0.6),
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
                  const SizedBox(height: 20),
                  // Theme Toggle Switch
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontSize: 16,
                            // Use theme color
                            color: colorScheme.onBackground,
                          ),
                        ),
                        Obx(() => Switch(
                              value: themeController.isDarkMode,
                              onChanged: (value) {
                                themeController.toggleTheme();
                              },
                              activeColor: colorScheme.primary,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80), // Add space below switch to avoid navbar overlap
                ]),
              ],
            ),
          ),
          const Navbar()
        ],
      ),
    );
  }
}
