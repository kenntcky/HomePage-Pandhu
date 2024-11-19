import 'package:get/get.dart';

import '../controllers/gantilok_failed_controller.dart';

class GantilokFailedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GantilokFailedController>(
      () => GantilokFailedController(),
    );
  }
}
