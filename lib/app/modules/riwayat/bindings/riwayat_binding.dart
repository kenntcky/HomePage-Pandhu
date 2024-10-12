import 'package:get/get.dart';

import '../controllers/riwayat_controller.dart';

class RiwayatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatController>(
      () => RiwayatController(),
    );
  }
}
