import 'package:aplikasi_pandhu/app/modules/posko/local_widgets/detail_posko.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/posko_controller.dart';

class PoskoView extends GetView<PoskoController> {
  const PoskoView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posko Gempa'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final List<Map<String, dynamic>> poskos = controller.poskoList;
        final Map<String, dynamic> selectedPosko = poskos.isNotEmpty ? poskos[0] : {};
        
        // Default coordinate jika tidak ada posko
        double latitude = -6.984034;
        double longitude = 110.409990;
        
        if (poskos.isNotEmpty) {
          latitude = double.tryParse(selectedPosko['latitude'].toString()) ?? latitude;
          longitude = double.tryParse(selectedPosko['longitude'].toString()) ?? longitude;
        }
        
        return Stack(
          children: [
            // Map display at the top
            Positioned.fill(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(latitude, longitude),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.sipandhu.aplikasi_pandhu',
                  ),
                  MarkerLayer(
                    markers: poskos.map((posko) {
                      final lat = double.tryParse(posko['latitude'].toString()) ?? 0.0;
                      final lng = double.tryParse(posko['longitude'].toString()) ?? 0.0;
                      
                      return Marker(
                        point: LatLng(lat, lng),
                        child: Image.asset(
                          'asset/img/icon/pin_posko.png',
                          width: 40,
                          height: 40,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // Offline indicator if needed
            if (!controller.isOnline.value)
              Positioned(
                top: 20,
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
                        'Mode Offline - Menampilkan data tersimpan',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Draggable sheet with posko details
            DraggableScrollableSheet(
              initialChildSize: 0.37,
              minChildSize: 0.37,
              maxChildSize: 0.65,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
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
                          color: colorScheme.onSurface.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      
                      // Scrollable content
                      Flexible(
                        child: ClipRRect(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            clipBehavior: Clip.none,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: poskos.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Text(
                                      'Tidak ada data posko tersedia',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Plus Jakarta Sans',
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                children: [
                                  Container(
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      color: colorScheme.surface, 
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            selectedPosko['alamat'] ?? 'Alamat tidak tersedia',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: colorScheme.onBackground,
                                              fontSize: 16,
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${selectedPosko['kota'] ?? ''}, ${selectedPosko['kodepos'] ?? ''}',
                                            style: TextStyle(
                                                color: colorScheme.onBackground.withOpacity(0.6),
                                                fontSize: 12,
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                          ),
                                          IntrinsicWidth(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              height: 38,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    width: 1,
                                                    strokeAlign: BorderSide.strokeAlignCenter,
                                                    color: const Color(0xFF99D65C),
                                                  ),
                                                  borderRadius: BorderRadius.circular(12),
                                                )
                                              ),
                                              child: Center(
                                                child: Text(
                                                  selectedPosko['status'] ?? 'TIDAK AKTIF',
                                                  style: TextStyle(
                                                    color: const Color(0xFF99D65C),
                                                    fontSize: 14,
                                                    fontFamily: 'Plus Jakarta Sans',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Your second container
                                  Container(
                                    height: 195,
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      borderRadius: BorderRadius.circular(24)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          DetailPosko(
                                            headline: 'Telepon', 
                                            detailicon: 'asset/img/icon/clock.png', 
                                            detaildata: selectedPosko['telepon'] ?? 'Tidak tersedia'
                                          ),
                                          DetailPosko(
                                            headline: 'Instagram', 
                                            detailicon: 'asset/img/icon/coordinate.png', 
                                            detaildata: selectedPosko['instagram'] ?? 'Tidak tersedia'
                                          ),
                                          DetailPosko(
                                            headline: 'Email', 
                                            detailicon: 'asset/img/icon/distance.png', 
                                            detaildata: selectedPosko['email'] ?? 'Tidak tersedia'
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
                          border: Border(),
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
        );
      }),
    );
  }
}
