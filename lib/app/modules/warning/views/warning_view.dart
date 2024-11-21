import 'package:aplikasi_pandhu/app/modules/warning/local_widgets/panduan.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/warning_controller.dart';

class WarningView extends GetView<WarningController> {
  WarningView({super.key});
  final  WarningController controller = Get.put( WarningController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6643C),
      body: Obx(() {
        return Stack(
          children: [
            // Tampilan pertama (Warning)
            if (controller.isWarningVisible.value)
              Center(
                child: Image.asset("asset/img/icon/danger-1.png")
              ),
            
            // Tampilan kedua (Instruksi)
            if (!controller.isWarningVisible.value)
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                              'Evakuasi Darurat',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                            ),
                        Container(
                          // height: 500,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              Panduan(
                                icon: "asset/img/icon/logout.png",
                                text: "Keluar dari bangunan secepat mungkin menuju lapangan terbuka",
                                height: 88,
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Panduan(
                                icon: "asset/img/icon/Vector.png",
                                text: "Jika tidak sempat, gunakan bantal untuk melindungi kepala dan berlindung di bawah meja",
                                height: 112,
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Panduan(
                                icon: "asset/img/icon/danger.png",
                                text: "Hindari benda-benda yang mudah pecah",
                                height: 88,
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Panduan(
                                icon: "asset/img/icon/material-symbols_waves.png",
                                text: "Jika gempa terjadi selama 20 menit, evakuasi ke dataran tinggi selama 20 menit, karena tsunami akan datang",
                                height: 112,
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Panduan(
                                icon: "asset/img/icon/bi_phone-fill.png",
                                text: "Jaga ponsel Anda dan selalu bersama keluarga Anda. Berhati-hatilah",
                                height: 88,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 185,
                              height: 52,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                    'Keluar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                    ),
                                ),
                              ),
                            ),
                            Container(
                              width: 185,
                              height: 52,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Center(
                                child: Text(
                                    'Lanjutkan',
                                      style: TextStyle(
                                        color: Color(0xFFF6643C),
                                        fontSize: 16,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                    ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                      ],
                    )
                  ),
                )
              ),
          ],
        );
      }),
    );
  }
}
