import 'package:get/get.dart';

import '../controllers/detail_gempa_controller.dart';

class DetailGempaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailGempaController>(
      () => DetailGempaController(),
    );
  }
}
