import 'package:get/get.dart';
import 'package:aplikasi_pandhu/app/data/models/posko_model.dart';
import 'package:aplikasi_pandhu/app/data/services/posko_service.dart';
import 'package:latlong2/latlong.dart';

class PoskoController extends GetxController {
  final PoskoService _poskoService = PoskoService();
  
  final RxList<PoskoModel> poskos = <PoskoModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<PoskoModel?> selectedPosko = Rx<PoskoModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchPoskos();
  }

  // Fetch all poskos from Firestore
  void fetchPoskos() {
    isLoading.value = true;
    isError.value = false;
    
    try {
      _poskoService.getPoskos().listen(
        (data) {
          poskos.value = data;
          isLoading.value = false;
          
          // Tidak otomatis memilih posko pertama
          // Pengguna harus mengklik marker pada peta untuk memilih posko
        },
        onError: (error) {
          isLoading.value = false;
          isError.value = true;
          errorMessage.value = 'Error fetching poskos: $error';
          print('Error fetching poskos: $error');
        }
      );
    } catch (e) {
      isLoading.value = false;
      isError.value = true;
      errorMessage.value = 'Error fetching poskos: $e';
      print('Error fetching poskos: $e');
    }
  }

  // Select a posko by ID
  void selectPoskoById(String id) {
    final posko = poskos.firstWhere((p) => p.id == id, orElse: () => poskos.first);
    selectedPosko.value = posko;
  }

  // Get the currently selected posko's LatLng
  LatLng getSelectedPoskoLatLng() {
    final posko = selectedPosko.value;
    if (posko != null) {
      return LatLng(posko.latitude, posko.longitude);
    }
    // Default to Semarang if no posko is selected
    return const LatLng(-6.984034, 110.409990);
  }

  // Add sample data to Firestore (call this method once to populate the database)
  Future<void> addSampleData() async {
    try {
      await _poskoService.addSamplePoskos();
      fetchPoskos();
    } catch (e) {
      print('Error adding sample data: $e');
    }
  }
}
