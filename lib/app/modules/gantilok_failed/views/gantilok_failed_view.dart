import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gantilok_failed_controller.dart';

class GantilokFailedView extends GetView<GantilokFailedController> {
  const GantilokFailedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(), 
            Column(
              children: [
                Image.asset("./asset/img/image/silang.png"),
                const Text(
                'Lokasi Anda tidak terdeteksi',
                textAlign: TextAlign.center,
                style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                ),
                ),
                const SizedBox(height: 12),
                const Text(
                'Sepertinya sedang ada kesalahan ',
                textAlign: TextAlign.center,
                style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 0.09,
                ),
                )
              ],
            ),
            const Spacer(), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      width: 350,
                      height: 52,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFF6643C),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Ulangi',
                          style: TextStyle(
                            color: Color(0xFFF6643C),
                            fontSize: 16,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
