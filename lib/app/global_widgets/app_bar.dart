// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_pandhu/app/modules/permission/controllers/permission_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class appBar extends StatefulWidget {
  const appBar({super.key});

  @override
  State<appBar> createState() => _appBarState();
}

class _appBarState extends State<appBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
    );
  }
}