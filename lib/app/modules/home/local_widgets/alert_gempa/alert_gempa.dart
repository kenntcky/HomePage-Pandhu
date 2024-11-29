import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';

class alert_Gempa extends StatelessWidget {
  const alert_Gempa({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.WARNING);
      },
      child: const green_Alert()
    );
  }
}

class red_Alert extends StatelessWidget {
  const red_Alert({super.key});

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
                                  height: 17,
                                ),
                                Container(
                                  width: 210,
                                  child: Text(
                                    'Hati-hati gempa sedang terjadi di wilayah Kota Semarang.',
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
                );
  }
}

class yellow_Alert extends StatelessWidget {
  const yellow_Alert({super.key});

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
                                  height: 17,
                                ),
                                Container(
                                  width: 210,
                                  child: Text(
                                    'Hati-hati gempa sedang terjadi di wilayah Kota Semarang.',
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

class green_Alert extends StatelessWidget {
  const green_Alert({super.key});

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
                                'Gempa Sedang Terjadi',
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
                                    'Hati-hati gempa sedang terjadi di wilayah Kota Semarang.',
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