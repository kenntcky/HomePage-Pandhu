import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/permission_controller.dart';

class PermissionView extends GetView<PermissionController> {
  PermissionView({super.key});
  final controller = Get.put(PermissionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                "asset/img/logo/logo-pandu.png",
                width: 14.88,
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Pandhu',
                  style: TextStyle(
                    color: Color(0xFFF6643C),
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 106,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Perizinan',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Untuk mendapatkan pengalaman yang lebih baik dalam menggunakan aplikasi, Pandhu menyarankan Anda untuk:',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 382,
                        height: 350,
                        decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [Color(0xFFECECEC), Colors.white],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 36),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 170,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "asset/img/image/3dlocation.png",
                                    ),
                                    Text(
                                      'Izin Lokasi',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 170,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "asset/img/image/folder.png",
                                    ),
                                    Text(
                                      'Izin Penyimpanan',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.determinePosition();
                        controller.getAndSetHumanReadable();
                      },
                      child: Container(
                        width: 382,
                        height: 52,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        decoration: ShapeDecoration(
                            color: Color(0xFFF6643C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        child: Text(
                          'Setuju',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: 382,
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Dengan melanjutkan, Anda setuju dengan \n',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 16,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Kebijikan privasi  ',
                              style: TextStyle(color: Colors.orange),
                            ),
                            TextSpan(
                                text: '& ',
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                )),
                            TextSpan(
                                text: 'Syarat ketentuan',
                                style: TextStyle(color: Colors.orange))
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
