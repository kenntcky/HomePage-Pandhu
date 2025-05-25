import 'package:aplikasi_pandhu/app/modules/posko/local_widgets/detail_posko.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:aplikasi_pandhu/app/modules/posko/views/manage_posko_view.dart';

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
        // Remove the add button, keep only settings button
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Kelola Posko',
            onPressed: () => Get.to(() => const ManagePoskoView()),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map display at the top
          Positioned.fill(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.isError.value) {
                return Center(child: Text('Error: ${controller.errorMessage.value}'));
              }
              
              // If no poskos available
              if (controller.poskos.isEmpty) {
                return const Center(child: Text('Tidak ada posko tersedia'));
              }
              
              return FlutterMap(
                options: MapOptions(
                  initialCenter: controller.getSelectedPoskoLatLng(),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.sipandhu.aplikasi_pandhu',
                  ),
                  MarkerLayer(
                    markers: controller.poskos.map((posko) {
                      return Marker(
                        point: LatLng(posko.latitude, posko.longitude),
                        child: GestureDetector(
                          onTap: () => controller.selectedPosko.value = posko,
                          child: Image.asset(
                            'asset/img/icon/pin_posko.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }),
          ),
          
          // Draggable sheet with posko details
          DraggableScrollableSheet(
            initialChildSize: 0.37,
            minChildSize: 0.37,
            maxChildSize: 0.65,
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
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        // Use a less prominent theme color
                        color: colorScheme.onSurface.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // Scrollable content
                    Flexible(  // Changed from Expanded to Flexible
                      child: ClipRRect(  // Added ClipRRect to clip content
                        child: SingleChildScrollView(
                          controller: scrollController,
                          // clipBehavior: Clip.none,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Obx(() {
                              final selectedPosko = controller.selectedPosko.value;
                              
                              if (selectedPosko == null) {
                                return const Center(
                                  child: Text('Pilih posko pada peta'),
                                );
                              }
                              
                              return Column(
                              children: [
                                Container(
                                  // height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: colorScheme.surface, 
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            selectedPosko.alamat,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: colorScheme.onBackground,
                                            fontSize: 16,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                          Text(selectedPosko.lokasi,
                                        style: TextStyle(
                                              color: colorScheme.onBackground.withOpacity(0.6),
                                              fontSize: 12,
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                        ),
                                        const SizedBox(height: 8),
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
                                                  selectedPosko.isOpen24Hours ? 'BUKA 24 JAM' : 'BUKA TERBATAS',
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
                                
                                // Jarak antara container pertama dan kedua
                                const SizedBox(height: 10),
                                
                                // Container kedua detail posko
                                Container(
                                  // Menghapus height tetap untuk responsivitas
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(24)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        DetailPosko(
                                          headline: 'Telepon', 
                                          detailicon: 'asset/img/icon/clock.png', 
                                          detaildata: selectedPosko.telepon
                                        ),
                                        const SizedBox(height: 5),
                                        DetailPosko(
                                          headline: 'Instagram', 
                                          detailicon: 'asset/img/icon/coordinate.png', 
                                          detaildata: selectedPosko.instagram
                                        ),
                                        const SizedBox(height: 5),
                                        DetailPosko(
                                          headline: 'Email', 
                                          detailicon: 'asset/img/icon/distance.png', 
                                          detaildata: selectedPosko.email
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              );
                            }),
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
