// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:shared_preferences/shared_preferences.dart';

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

  const Kotakgempa({
    super.key,
    required this.magnitude,
    required this.lokasi,
    required this.jarak,
    required this.jam});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 203,
          width: 187,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Container(
                  height: 97,
                  width: 175,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 184, 181, 181),
                      borderRadius: BorderRadius.circular(4)),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Text(
                        lokasi,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "asset/img/location.png",
                                  width: 16,
                                  height: 16,
                                ),
                                 Text(
                                  jarak,
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 12,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  jam,
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 12,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 0.12,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
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
                color: Colors.white.withOpacity(0.30000001192092896),
                borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFF6643C),
                  ),
                  Text(
                    '$magnitude M',
                    style: TextStyle(
                      color: Color(0xFFF6643C),
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
    );
  }
}