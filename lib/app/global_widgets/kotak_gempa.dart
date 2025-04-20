// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'dart:typed_data';

Future<String> calculateDistance(double gempaLat, double gempaLon) async {
    final prefs = await SharedPreferences.getInstance();
    
    double? userLat;
    double? userLon;
    
    // Keep checking every 1500 milliseconds until values are found (with a max limit)
    int maxAttempts = 10; // For example, it will retry 10 times (5 seconds total)
    int attempts = 0;

    while (userLat == null || userLon == null) {
      userLat = prefs.getDouble('userLat');
      userLon = prefs.getDouble('userLon');

      if (userLat != null && userLon != null) {
        break;
      }

      if (attempts >= maxAttempts) {
        return "Location not available";
      }

      // Wait for 1500 milliseconds before checking again
      await Future.delayed(Duration(milliseconds: 1500));
      attempts++;
    }

    // Haversine formula to calculate the distance between two points
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((gempaLat - userLat) * p) / 2 +
        c(userLat * p) * c(gempaLat * p) *
        (1 - c((gempaLon - userLon) * p)) / 2;
    double distance = 12742 * asin(sqrt(a));

    // Round the distance to one decimal place
    double roundedDistance = double.parse((distance).toStringAsFixed(1));
    return "$roundedDistance km";
}

class Kotakgempa extends StatelessWidget {
  final String magnitude;
  final String lokasi;
  final String jarak;
  final String jam;
  final String tanggal;
  final String coordinates;
  final String lintang;
  final String bujur;
  final String kedalaman;
  final String potensi;
  final String dirasakan;
  final Uint8List? shakemap;

  const Kotakgempa({
    super.key,
    required this.magnitude,
    required this.lokasi,
    required this.jarak,
    required this.jam,
    required this.tanggal,
    required this.coordinates,
    required this.lintang,
    required this.bujur,
    required this.kedalaman,
    required this.potensi,
    required this.dirasakan,
    this.shakemap,
  });

  @override
  Widget build(BuildContext context) {
    // Get theme and color scheme
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.DETAIL_GEMPA,
          arguments: {
            'magnitude': magnitude,
            'lokasi': lokasi,
            'jarak': jarak,
            'jam': jam,
            'tanggal': tanggal,
            'coordinates': coordinates,
            'lintang': lintang,
            'bujur': bujur,
            'kedalaman': kedalaman,
            'potensi': potensi,
            'dirasakan': dirasakan,
            'shakemap': shakemap,
          }
        );
      },
      child: Stack(
        children: [
          Container(
            height: 210,
            width: 187,
            decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(10)
                ),
            // alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 97,
                    width: 175,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("asset/img/image/display-kotakgempa.png"),
                          fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                        lokasi,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                        textBaseline: TextBaseline.ideographic,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "asset/img/icon/location.png",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                              jarak,
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 12,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                          ),
                          Text(
                            jam,
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 12,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Container(
              width: 81,
              height: 33,
              decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: colorScheme.error,
                    ),
                    Text(
                      '$magnitude M',
                      style: TextStyle(
                        color: colorScheme.error,
                        fontSize: 12,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}