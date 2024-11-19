import 'package:get/get.dart';

import '../controllers/gantilok_editlok_controller.dart';

class GantilokEditlokBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GantilokEditlokController>(
      () => GantilokEditlokController(),
    );
  }
}
