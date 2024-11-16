import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 82,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 68),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.HOME);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            child: Image.asset(
                              "asset/img/icon/home-onclick.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text(
                            'Beranda',
                            style: TextStyle(
                              color: Color(0xFFF6643C),
                              fontSize: 12,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.RIWAYAT);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            child: Image.asset(
                              "asset/img/icon/clock-idle.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text(
                            'Riwayat',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 12,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    )
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
                    Get.toNamed(Routes.CHATAI);
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: ShapeDecoration(
                      color: Color(0xFFF6643C),
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
                SizedBox(
                  height: 15,
                ),
                Text(
                  'SiPandhu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
