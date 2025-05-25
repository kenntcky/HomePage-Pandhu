import 'package:get/get.dart';

import '../controllers/main_artikel_controller.dart';

class MainArtikelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainArtikelController>(
      () => MainArtikelController(),
    );
  }
}
