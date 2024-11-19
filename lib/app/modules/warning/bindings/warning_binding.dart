import 'package:get/get.dart';

import '../controllers/warning_controller.dart';

class WarningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WarningController>(
      () => WarningController(),
    );
  }
}
