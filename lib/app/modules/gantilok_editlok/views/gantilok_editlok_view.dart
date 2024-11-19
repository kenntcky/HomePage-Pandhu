import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gantilok_editlok_controller.dart';

class GantilokEditlokView extends GetView<GantilokEditlokController> {
  const GantilokEditlokView({super.key});
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Perizinan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pandhu akan mengakses lokasi Anda untuk menentukan lokasi Anda sekarang dengan akurat dan segala informasi mengenai gempa akan diubah',
                style: TextStyle(
                  color: Color(0xFF49454F),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Tidak",
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Izinkan & Aktifkan",
                      style: TextStyle(
                        color: Color(0xFFF6643C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(), 
            Column(
              children: [
                Image.asset("./asset/img/image/gantilokasi.png"),
                const Text(
                  'Apakah Anda yakin ingin \nmengubah lokasi Anda?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Segala informasi mengenai \ngempa akan diubah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
                          'Tidak',
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
                    onTap: _showPermissionDialog,
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
                          'Setuju',
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
