// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/artikel_controller.dart';

class ArtikelView extends GetView<ArtikelController> {
  const ArtikelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Stack(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child:
                     Image.asset(
                      "asset/img/image/artikel-gelap.png",
                      )
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 140,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1014,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                color: Color(0xFFF8F8F8),
                                borderRadius: BorderRadius.circular(25)
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                      'Mengenal Bahaya Gempa Bumi',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                      ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Apa Itu Gempa Bumi?\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Gempa bumi adalah getaran atau guncangan yang terjadi di permukaan bumi akibat pelepasan energi secara tiba-tiba di dalam lapisan bumi. Energi ini berasal dari pergerakan lempeng tektonik, aktivitas vulkanik, atau bahkan ledakan buatan. Getaran gempa dapat dirasakan oleh manusia, dan sering kali membawa dampak besar terhadap kehidupan, termasuk kerusakan bangunan, kehilangan nyawa, dan gangguan sosial.\n\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Mengapa Penting Mengetahui Mitigasi?\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Indonesia adalah salah satu negara yang berada di wilayah cincin api Pasifik (Ring of Fire), yang membuatnya rentan terhadap aktivitas gempa bumi. Dengan tingkat risiko yang tinggi, memahami cara mitigasi menjadi hal yang sangat penting untuk mengurangi dampak gempa.\n\nMitigasi gempa bukan hanya soal tindakan setelah bencana terjadi, tetapi juga mencakup langkah-langkah persiapan sebelum gempa dan perilaku yang tepat saat gempa berlangsung. Dengan mitigasi yang baik, masyarakat dapat:\n- Mengurangi risiko cedera dan kematian.\n- Meminimalkan kerusakan properti.\n- Mempercepat proses pemulihan setelah bencana.\n\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Jenis-Jenis Gempa Bumi\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '1. ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Gempa Tektonik',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ': Disebabkan oleh pergerakan lempeng tektonik. Ini adalah jenis gempa yang paling umum dan sering kali paling merusak.\n2. ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Gempa Vulkanik',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ': Terjadi akibat aktivitas vulkanik, biasanya menjelang atau saat gunung berapi meletus.\n3. ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Gempa Runtuhan',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ': Disebabkan oleh runtuhnya gua atau rongga bawah tanah, biasanya memiliki skala yang kecil.\n4. ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Gempa Buatan',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ': Disebabkan oleh aktivitas manusia, seperti ledakan atau pertambangan.\n\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Dampak Gempa Bumi\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Gempa bumi dapat menyebabkan dampak besar, baik secara langsung maupun tidak langsung. Dampak langsung meliputi kerusakan fisik seperti bangunan runtuh, jalan rusak, dan jatuhnya korban jiwa. Dampak tidak langsung dapat berupa bencana lanjutan seperti kebakaran, tsunami, atau gangguan sosial ekonomi.\n\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Pentingnya Kesadaran dan Edukasi\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Kesadaran dan edukasi masyarakat adalah kunci utama dalam menghadapi gempa bumi. Dengan memahami risiko gempa dan cara mitigasinya, masyarakat dapat lebih siap menghadapi situasi darurat. Pemerintah dan berbagai lembaga juga memiliki peran penting dalam menyediakan informasi, pelatihan, dan infrastruktur yang mendukung upaya mitigasi.\n',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                    ),
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}