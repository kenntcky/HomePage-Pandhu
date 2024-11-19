import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gantilok_success_controller.dart';

class GantilokSuccessView extends GetView<GantilokSuccessController> {
  const GantilokSuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(), 
            Column(
              children: [
                Image.asset("./asset/img/image/ceklis.png"),
                const Text(
'Senayan, Jakarta, Indonesia',
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
'Lokasi Anda berhasil diubah',
textAlign: TextAlign.center,
style: TextStyle(
color: Color(0xFF666666),
fontSize: 16,
fontFamily: 'Plus Jakarta Sans',
fontWeight: FontWeight.w400,

),
)
              ],
            ),
            const Spacer(), // Spacer kedua untuk mendorong tombol ke bawah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Aksi tombol "Tidak"
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
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
                  GestureDetector(                   
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 52,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF6643C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Benar',
                          style: TextStyle(
                            color: Colors.white,
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
