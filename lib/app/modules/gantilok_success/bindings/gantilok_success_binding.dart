import 'package:get/get.dart';

import '../controllers/gantilok_success_controller.dart';

class GantilokSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GantilokSuccessController>(
      () => GantilokSuccessController(),
    );
  }
}
