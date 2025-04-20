import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class WarningController extends GetxController {
  var isWarningVisible = true.obs;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 3), () {
      isWarningVisible.value = false;
    });
  }

  Future<Map<String, dynamic>> getLatestEarthquake() async {
    try {
      final event = await _databaseRef.orderByKey().limitToLast(1).once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final entry = data.entries.first;
        
        if (entry.value['Infogempa']?['gempa'] != null) {
          final gempaData = entry.value['Infogempa']['gempa'];
          return {
            'magnitude': gempaData['Magnitude'],
            'lokasi': gempaData['Wilayah'],
            'jarak': gempaData['jarak'],
            'jam': gempaData['Jam'],
            'tanggal': gempaData['Tanggal'],
            'coordinates': gempaData['Coordinates'],
            'lintang': gempaData['Lintang'],
            'bujur': gempaData['Bujur'],
            'kedalaman': gempaData['Kedalaman'],
            'potensi': gempaData['Potensi'],
            'dirasakan': gempaData['Dirasakan'],
            'shakemap': gempaData['Shakemap'],
          };
        }
      }
      return {};
    } catch (e) {
      print('Error fetching latest earthquake: $e');
      return {};
    }
  }
}
