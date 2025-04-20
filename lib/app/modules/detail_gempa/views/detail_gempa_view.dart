import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../local_widgets/detail_eq.dart';
import '../local_widgets/infosr.dart';
import '../local_widgets/tsunami_potential.dart';
import '../../../../utils/connectivity_utils.dart';

class Googlemapflutter extends StatefulWidget {
  final Map<String, dynamic> gempaData;
  
  const Googlemapflutter({
    super.key,
    required this.gempaData,
  });

  @override
  State<Googlemapflutter> createState() => _GooglemapflutterState();
}

class _GooglemapflutterState extends State<Googlemapflutter> {
  late Map<String, dynamic> gempaData;
  List<double>? gempaCoordinates;
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    gempaData = widget.gempaData;
    getGempaCoordinates();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    final hasInternet = await ConnectivityUtils.hasInternetConnection();
    setState(() {
      isOnline = hasInternet;
    });
  }

  void getGempaCoordinates() {
    print(gempaData['shakemap']);
    String coordinatesBMKG = gempaData['coordinates'] ?? '';
    
    // Convert string coordinates to array
    List<String> parts = coordinatesBMKG.split(',');
    var coordinates = List<double>.filled(2, 0);

    if (parts.length == 2) {
      try {
        coordinates[0] = double.parse(parts[0].trim());
        coordinates[1] = double.parse(parts[1].trim());
        
        setState(() {
          gempaCoordinates = coordinates;
        });
      } catch (e) {
        print('Error parsing coordinates: $e');
        setState(() {
          gempaCoordinates = [0, 0]; // Default coordinates if parsing fails
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme and color scheme
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      // Use theme background color
      backgroundColor: theme.scaffoldBackgroundColor,
      body: gempaCoordinates == null
        ? const Center(child: CircularProgressIndicator())
        : Stack(
        children: [
          // Map container
          isOnline 
            ? FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(gempaCoordinates![0], gempaCoordinates![1]),
                  initialZoom: 7,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.sipandhu.aplikasi_pandhu',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(gempaCoordinates![0], gempaCoordinates![1]),
                        child: Image.asset(
                          'asset/img/icon/marker.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Container(
                width: double.infinity,
                height: 300, // Adjust height as needed
                child: gempaData['shakemap'] != null
                  ? Image.memory(
                      gempaData['shakemap'],
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Text(
                        'Shakemap tidak tersedia',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                          // Reverted to white as requested
                          color: Colors.white,
                        ),
                      ),
                    ),
              ),

          // Offline indicator if needed
          if (!isOnline)
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'Mode Offline - Menampilkan Shakemap',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                AppBar(
                  toolbarHeight: 78,
                  title: Text(
                    'Informasi Gempa', 
                    // Use AppBar theme for title style automatically
                    // style: TextStyle(color: colorScheme.onPrimary), 
                  ),
                  leading: IconButton(
                    // Icon color should be handled by AppBar theme
                    icon: Icon(Icons.arrow_back /*, color: colorScheme.onPrimary*/),
                    onPressed: () => Get.back(),
                  ),
                  centerTitle: true,
                  // Use AppBar theme for background color automatically
                  // backgroundColor: colorScheme.primary, 
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.32,
            minChildSize: 0.32,
            maxChildSize: 0.57,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  // Removed background color to make sheet transparent
                  // color: colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag indicator
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        // Use a less prominent theme color
                        color: colorScheme.onSurface.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // Scrollable content
                    Flexible(  // Changed from Expanded to Flexible
                      child: ClipRRect(  // Added ClipRRect to clip content
                        child: SingleChildScrollView(
                          controller: scrollController,
                          clipBehavior: Clip.none,  // Prevent scrolling content from showing outside bounds
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),  // Removed padding bottom
                            child: Column(
                              children: [
                                // Your first container
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    // Use surface color
                                    color: colorScheme.surface, 
                                    // Removed the border property
                                    // border: Border.all(color: colorScheme.outlineVariant ?? colorScheme.onSurface.withOpacity(0.12), width: 1)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            infosr(
                                              satuangempa: gempaData['magnitude'],
                                              icongempa: 'asset/img/icon/sr.png',
                                              namabawah: 'Magnitudo',
                                            ),
                                            Container(
                                              width: 1,
                                              height: 70,
                                              // Use a subtle divider color
                                              color: colorScheme.onSurface.withOpacity(0.12),
                                            ),
                                            infosr(
                                              satuangempa: gempaData['lokasi'],
                                              icongempa: 'asset/img/icon/location.png',
                                              namabawah: 'Lokasi',
                                            ),
                                            Container(
                                              width: 1,
                                              height: 70,
                                              // Use a subtle divider color
                                              color: colorScheme.onSurface.withOpacity(0.12),
                                            ),
                                            infosr(
                                              satuangempa: gempaData['kedalaman'],
                                              icongempa: 'asset/img/icon/map.png',
                                              namabawah: 'Kedalaman',
                                            ),
                                          ],
                                        ),
                                        
                                        TsunamiPotential(potensi: gempaData['potensi'] ?? ''),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Your second container
                                Container(
                                  height: 195,
                                  decoration: BoxDecoration(
                                    // Use surface color for this container background
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(24)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DetailEq(
                                          headline: "Waktu",
                                          detailicon: "asset/img/icon/clock.png",
                                          detaildata: "${gempaData['tanggal']}, ${gempaData['jam']}"
                                        ),
                                        DetailEq(
                                          headline: "Koordinat",
                                          detailicon: "asset/img/icon/coordinate.png",
                                          detaildata: "${gempaCoordinates![0]}, ${gempaCoordinates![1]}"
                                        ),
                                        DetailEq(
                                          headline: "Jarak",
                                          detailicon: "asset/img/icon/distance.png",
                                          detaildata: gempaData['jarak']
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Fixed button at bottom
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        // color: Colors.white,
                        border: Border(
                          // top: BorderSide(
                          //   color: Colors.grey,
                          //   width: 0.5,
                          // ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.ARTIKEL);
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6643C),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Lebih lanjut',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Image.asset(
                                "asset/img/icon/arrow-right-white.png",
                                width: 24,
                                height: 24,
                                fit: BoxFit.fill,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}