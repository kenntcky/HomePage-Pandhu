// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class Artikel extends StatelessWidget {
  const Artikel({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme and color scheme
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.ARTIKEL);
      },
      child: Container(
        height: 288,
        width: 202,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset("asset/img/image/artikel.png")),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pandhu',
                    style: TextStyle(
                      color: colorScheme.error,
                      fontSize: 10,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '10 Sep 2024',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 10,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                      'Mengenal Bahaya Gempa Bumi',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Gempa bumi adalah getaran atau guncangan yang terjadi di permukaan bumi akibat pelepasan energi secara tiba-tiba di dalam lapisan bumi. Energi ini berasal dari pergerakan lempeng tektonik, aktivitas vulkanik, atau bahkan ledakan buatan. Getaran gempa dapat dirasakan oleh manusia, dan sering kali membawa dampak besar terhadap kehidupan, termasuk kerusakan bangunan, kehilangan nyawa, dan gangguan sosial.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 10,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 43,
                          height: 15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Baca',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 10,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Image.asset("asset/img/icon/arrow-right.png"),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
