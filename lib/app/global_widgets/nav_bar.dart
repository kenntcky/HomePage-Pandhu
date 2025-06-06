// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller NavBar ada dibawah ya teman teman

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final NavbarController navbarController = Get.put(NavbarController());

  @override
  Widget build(BuildContext context) {
    // Get theme and color scheme for background
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    // Define fixed colors for foreground elements
    const Color activeColor = Color(0xFFF6643C); // Original orange
    const Color inactiveColor = Color(0xFF666666); // Original grey
    const Color centerButtonColor = Color(0xFFF6643C); // Original orange

    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 82,
              // Use theme surface color for the background
              decoration: BoxDecoration(color: colorScheme.surface),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 68),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navbarController.changePage(0);
                        Get.toNamed(Routes.HOME);
                      },
                      child: Obx(() {
                        bool isActive = navbarController.currentIndex.value == 0;
                        return Column(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              child: Image.asset(
                                isActive
                                    ? "asset/img/icon/home-onclick.png"
                                    : "asset/img/icon/home-idle.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              'Beranda',
                              style: TextStyle(
                                // Use fixed active/inactive colors
                                color: isActive ? activeColor : inactiveColor,
                                fontSize: 12,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    GestureDetector(
                      onTap: () {
                        navbarController.changePage(1);
                        Get.toNamed(Routes.RIWAYAT);
                      },
                      child: Obx(() {
                        bool isActive = navbarController.currentIndex.value == 1;
                        return Column(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              child: Image.asset(
                                isActive
                                    ? "asset/img/icon/clock-onclick.png"
                                    : "asset/img/icon/clock-idle.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              'Riwayat',
                              style: TextStyle(
                                // Use fixed active/inactive colors
                                color: isActive ? activeColor : inactiveColor,
                                fontSize: 12,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.CHAT);
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: ShapeDecoration(
                      // Use fixed orange color
                      color: centerButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Container(
                      width: 20,
                      height: 20,
                      child: Image.asset("asset/img/icon/chat.png"),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'SiPandhu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // Use fixed grey color
                    color: inactiveColor,
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class NavbarController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
