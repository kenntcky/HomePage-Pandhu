import 'package:get/get.dart';

class WarningController extends GetxController {
  // State untuk mengontrol tampilan pertama dan kedua
  RxBool isWarningVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Timer untuk mengatur pergantian tampilan
    Future.delayed(Duration(seconds: 1), () {
      isWarningVisible.value = false;
    });
  }
}
