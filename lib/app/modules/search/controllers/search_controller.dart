import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../../main.dart';

class SearchPageController extends GetxController {
  //TODO: Implement SearchController

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  
  // Observable list for search results
  RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;

  Future<void> searchEarthquakeData(String query) async {
    print(query);
    List<Map<String, dynamic>> results = [];

    try {
      final event = await _databaseRef.once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
      print('masok not null');
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        data.forEach((key, value) async {
          if (value['Infogempa']['gempa']['Wilayah'] != null &&
              value['Infogempa']['gempa']['Wilayah'].toString().toLowerCase().contains(query.toLowerCase())) {
                print('ketemu!!!');
            // Convert string coordinates dari BMKG API ke array
            List<String> parts = value['Infogempa']['gempa']['Coordinates'].split(',');
            var gempaCoordinatesx = List<double>.filled(2, 0);

            if (parts.length == 2) {
              gempaCoordinatesx[0] = double.parse(parts[0].trim());
              gempaCoordinatesx[1] = double.parse(parts[1].trim());
            }

            double jarak = await calculateDistance(gempaCoordinatesx[0], gempaCoordinatesx[1]);
            results.add({
              "magnitude": value['Infogempa']['gempa']["Magnitude"],
              "wilayah": value['Infogempa']['gempa']["Wilayah"],
              "jarak": jarak,
              "jam": value['Infogempa']['gempa']["Jam"],
            });
          }
        });
      }
    } catch (e) {
      print("Error searching data: $e");
    }

    // Update the observable list
    searchResults.value = results;
  }
}
