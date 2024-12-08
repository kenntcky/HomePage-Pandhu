import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../../database.dart';
import '../../../../utils/connectivity_utils.dart';
import 'dart:math' show min;
import '../../../../main.dart';

class RiwayatController extends GetxController {
  final RxList<Map<String, dynamic>> gempaList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isOnline = true.obs;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      
      final hasInternet = await ConnectivityUtils.hasInternetConnection();
      isOnline.value = hasInternet;
      print('Riwayat: Internet connection status: ${hasInternet ? 'Online' : 'Offline'}');

      if (hasInternet) {
        await _loadFromFirebase();
      } else {
        print('Riwayat: No internet connection, loading from SQLite');
        await _loadFromSQLite();
      }
    } catch (e) {
      print('Riwayat: Error loading data: $e');
      print('Riwayat: Falling back to SQLite data');
      await _loadFromSQLite();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFromFirebase() async {
    try {
      print('Riwayat: Fetching data from Firebase');
      final event = await _databaseRef.once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        List<Map<String, dynamic>> earthquakes = [];

        print('Riwayat: Processing ${data.length} records from Firebase');

        // Convert the entries to a List so we can use await properly
        final entries = data.entries.toList();
        for (var entry in entries) {
          final value = entry.value;
          if (value['Infogempa'] != null && 
              value['Infogempa']['gempa'] != null && 
              value['Infogempa']['gempa']['Coordinates'] != null) {
                
            final dateTime = value['Infogempa']['gempa']["DateTime"];
            print('Riwayat: Processing earthquake with DateTime: $dateTime');
                
            // Convert coordinates string to array
            List<String> parts = value['Infogempa']['gempa']['Coordinates'].split(',');
            var gempaCoordinates = List<double>.filled(2, 0);

            if (parts.length == 2) {
              gempaCoordinates[0] = double.parse(parts[0].trim());
              gempaCoordinates[1] = double.parse(parts[1].trim());
            }

            final jarak = await calculateDistance(gempaCoordinates[0], gempaCoordinates[1]);
            
            final earthquakeData = {
              "magnitude": value['Infogempa']['gempa']["Magnitude"] ?? 'Tidak ada data',
              "wilayah": value['Infogempa']['gempa']["Wilayah"] ?? 'Tidak ada data',
              "jarak": jarak,
              "jam": value['Infogempa']['gempa']["Jam"] ?? 'Tidak ada data',
              "tanggal": value['Infogempa']['gempa']["Tanggal"] ?? 'Tidak ada data',
              "coordinates": value['Infogempa']['gempa']["Coordinates"] ?? 'Tidak ada data',
              "lintang": value['Infogempa']['gempa']["Lintang"] ?? 'Tidak ada data',
              "bujur": value['Infogempa']['gempa']["Bujur"] ?? 'Tidak ada data',
              "kedalaman": value['Infogempa']['gempa']["Kedalaman"] ?? 'Tidak ada data',
              "potensi": value['Infogempa']['gempa']["Potensi"] ?? 'Tidak ada data',
              "dirasakan": value['Infogempa']['gempa']["Dirasakan"] ?? 'Tidak ada data',
              "shakemap": value['Infogempa']['gempa']["Shakemap"],
              "dateTime": dateTime ?? '',
            };

            earthquakes.add(earthquakeData);
          }
        }

        print('Riwayat: Before sorting - First earthquake DateTime: ${earthquakes.isNotEmpty ? earthquakes.first['dateTime'] : 'no data'}');
        
        // Sort earthquakes by DateTime (newest first)
        earthquakes.sort((a, b) {
          final aDateTime = DateTime.parse(a['dateTime']);
          final bDateTime = DateTime.parse(b['dateTime']);
          return bDateTime.compareTo(aDateTime);
        });

        print('Riwayat: After sorting - First earthquake DateTime: ${earthquakes.isNotEmpty ? earthquakes.first['dateTime'] : 'no data'}');

        // Print the first few sorted earthquakes
        print('Riwayat: First 3 earthquakes after sorting:');
        for (var i = 0; i < min(3, earthquakes.length); i++) {
          print('Riwayat: ${i + 1}. DateTime: ${earthquakes[i]['dateTime']}, Tanggal: ${earthquakes[i]['tanggal']}, Jam: ${earthquakes[i]['jam']}');
        }

        gempaList.value = earthquakes;
        print('Riwayat: Successfully loaded ${earthquakes.length} records from Firebase');
      }
    } catch (e) {
      print('Riwayat: Error fetching from Firebase: $e');
      print('Riwayat: Stack trace: $e');
      throw e;
    }
  }

  Future<void> _loadFromSQLite() async {
    try {
      print('Riwayat: Loading data from SQLite');
      gempaList.value = await dbHelper.getAllGempa();
      print('Riwayat: Successfully loaded ${gempaList.length} records from SQLite');
    } catch (e) {
      print('Riwayat: Error loading from SQLite: $e');
      gempaList.value = [];
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }
}
