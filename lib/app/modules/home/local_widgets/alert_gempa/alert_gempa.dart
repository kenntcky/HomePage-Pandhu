// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:aplikasi_pandhu/app/modules/home/controllers/home_controller.dart';

class AlertGempa extends GetView<HomeController> {
  const AlertGempa({super.key});

  Widget _buildAlertWidget(Map<String, dynamic> gempa) {
    if (gempa.isEmpty) return const SizedBox.shrink();
    
    final DateTime notificationTime = DateTime.tryParse(gempa['notificationTime'] ?? '') ?? 
                                    DateTime.tryParse(gempa['dateTime'] ?? '') ?? 
                                    DateTime.now();
    final DateTime now = DateTime.now();
    final difference = now.difference(notificationTime);
    
    if (difference.inMinutes > 5) return const Standby();
    
    final double distance = double.tryParse(gempa['jarak']?.toString().replaceAll(' km', '') ?? '') ?? 0;
    final String location = gempa['wilayah'] ?? '';
    
    if (distance <= 25) {
      return RedAlert(distance: '${distance.toStringAsFixed(1)} km', location: location);
    } else if (distance <= 50) {
      return YellowAlert(distance: '${distance.toStringAsFixed(1)} km', location: location);
    } else {
      print('notificationTime: ${gempa['notificationTime']}');
      return GreenAlert(distance: '${distance.toStringAsFixed(1)} km', location: location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () {
        Get.toNamed(Routes.WARNING);
      },
      child: _buildAlertWidget(controller.latestEarthquake.value),
    ));
  }
}

class RedAlert extends StatelessWidget {
  final String distance;
  final String location;
  
  const RedAlert({
    super.key, 
    required this.distance,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                      SizedBox(height: 17),
                      Container(
                        width: 210,
                        child: Text(
                          'Hati-hati, gempa sedang terjadi $distance dari anda. $location',
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
                  aspectRatio: 1,
                  child: Image.asset(
                    "asset/img/image/gempa.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YellowAlert extends StatelessWidget {
  final String distance;
  final String location;
  
  const YellowAlert({
    super.key, 
    required this.distance,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 382,
        height: 201,
        decoration: ShapeDecoration(
          color: Color(0xFFF1D900),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x99F1D900),
              blurRadius: 20,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                      SizedBox(height: 17),
                      Container(
                        width: 210,
                        child: Text(
                          'Hati-hati, gempa sedang terjadi $distance dari anda. $location',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFFF9F099),
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
                  aspectRatio: 1,
                  child: Image.asset(
                    "asset/img/image/gempa.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GreenAlert extends StatelessWidget {
  final String distance;
  final String location;
  
  const GreenAlert({
    super.key, 
    required this.distance,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 382,
        height: 201,
        decoration: ShapeDecoration(
          color: Color(0xFF8BD73F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x998BD83F),
              blurRadius: 20,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                      SizedBox(height: 17),
                      Container(
                        width: 210,
                        child: Text(
                          'Hati-hati, gempa sedang terjadi $distance dari anda. $location',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFFD1EFB2),
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
                  aspectRatio: 1,
                  child: Image.asset(
                    "asset/img/image/gempa.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Standby extends StatelessWidget {
  const Standby({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: 382,
                    height: 201,
                    decoration: ShapeDecoration(
                      color: Color(0xFF8BD73F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x998BD83F),
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
                                'Tidak ada gempa',
                                style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 17,
                                ),
                                Container(
                                  width: 210,
                                  child: Text(
                                    'Tetap waspada akan terjadinya bencana alam gempa.',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFFD1EFB2),
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
                );
  }
}