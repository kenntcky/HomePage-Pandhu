import 'package:get/get.dart';
import '../../../../database.dart';

class RiwayatController extends GetxController {
  final RxList<Map<String, dynamic>> gempaList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final db = DatabaseHelper();
      gempaList.value = await db.getAllGempa();
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      final db = DatabaseHelper();
      gempaList.value = await db.getAllGempa();
    } catch (e) {
      print('Error refreshing data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
