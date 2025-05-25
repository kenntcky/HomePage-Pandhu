import 'package:get/get.dart';

import '../controllers/posko_controller.dart';

class PoskoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoskoController>(
      () => PoskoController(),
    );
  }
}
