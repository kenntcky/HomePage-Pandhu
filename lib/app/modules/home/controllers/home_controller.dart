import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../../database.dart';
import '../../../../utils/connectivity_utils.dart';
import '../../../../main.dart';
import 'dart:math' show min;

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> gempaList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> gempaNearestList = <Map<String, dynamic>>[].obs;
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
      print('Home: Internet connection status: ${hasInternet ? 'Online' : 'Offline'}');

      if (hasInternet) {
        await _loadFromFirebase();
      } else {
        print('Home: No internet connection, loading from SQLite');
        await _loadFromSQLite();
      }
    } catch (e) {
      print('Home: Error loading data: $e');
      print('Home: Falling back to SQLite data');
      await _loadFromSQLite();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFromFirebase() async {
    try {
      print('Home: Fetching data from Firebase');
      final event = await _databaseRef.once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        List<Map<String, dynamic>> earthquakes = [];
        List<Map<String, dynamic>> nearestEarthquakes = [];

        print('Home: Processing ${data.length} records from Firebase');

        // Convert the entries to a List so we can use await properly
        final entries = data.entries.toList();
        for (var entry in entries) {
          final value = entry.value;
          if (value['Infogempa'] != null && 
              value['Infogempa']['gempa'] != null && 
              value['Infogempa']['gempa']['Coordinates'] != null) {
                
            final dateTime = value['Infogempa']['gempa']["DateTime"];
            print('Home: Processing earthquake with DateTime: $dateTime');
                
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
            
            // Add to nearest earthquakes if distance is less than 500km
            if (jarak < 500) {
              nearestEarthquakes.add(earthquakeData);
            }
          }
        }

        print('Home: Before sorting - First earthquake DateTime: ${earthquakes.isNotEmpty ? earthquakes.first['dateTime'] : 'no data'}');
        
        // Sort earthquakes by DateTime (newest first)
        earthquakes.sort((a, b) {
          final aDateTime = DateTime.parse(a['dateTime']);
          final bDateTime = DateTime.parse(b['dateTime']);
          return bDateTime.compareTo(aDateTime);
        });

        print('Home: After sorting - First earthquake DateTime: ${earthquakes.isNotEmpty ? earthquakes.first['dateTime'] : 'no data'}');

        // Sort nearest earthquakes by DateTime (newest first)
        nearestEarthquakes.sort((a, b) {
          final aDateTime = DateTime.parse(a['dateTime']);
          final bDateTime = DateTime.parse(b['dateTime']);
          return bDateTime.compareTo(aDateTime);
        });

        // Take only the latest 25 earthquakes for the main list
        earthquakes = earthquakes.take(25).toList();

        // Print the first few sorted earthquakes
        print('Home: First 3 earthquakes after sorting:');
        for (var i = 0; i < min(3, earthquakes.length); i++) {
          print('Home: ${i + 1}. DateTime: ${earthquakes[i]['dateTime']}, Tanggal: ${earthquakes[i]['tanggal']}, Jam: ${earthquakes[i]['jam']}');
        }

        gempaList.value = earthquakes;
        gempaNearestList.value = nearestEarthquakes;
        print('Home: Successfully loaded ${earthquakes.length} records from Firebase');
        print('Home: Found ${nearestEarthquakes.length} nearby earthquakes (under 500km)');
      }
    } catch (e) {
      print('Home: Error fetching from Firebase: $e');
      print('Home: Stack trace: $e');
      throw e;
    }
  }

  Future<void> _loadFromSQLite() async {
    try {
      print('Home: Loading data from SQLite');
      gempaList.value = await dbHelper.getAllGempa();
      
      // Filter nearest earthquakes
      List<Map<String, dynamic>> nearestQuakes = gempaList
          .where((quake) => (double.tryParse(quake['jarak'].toString()) ?? double.infinity) < 100)
          .toList();
      
      gempaNearestList.value = nearestQuakes;
      print('Home: Successfully loaded ${gempaList.length} records from SQLite');
      print('Home: Found ${nearestQuakes.length} nearby earthquakes in SQLite');
    } catch (e) {
      print('Home: Error loading from SQLite: $e');
      gempaList.value = [];
      gempaNearestList.value = [];
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }

  Future<String> getHumanReadable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double userLatitude = prefs.getDouble('userLatitude') ?? 0.0;
      double userLongitude = prefs.getDouble('userLongitude') ?? 0.0;

      if (userLatitude == 0.0 || userLongitude == 0.0) {
        return "Koordinat tidak valid.";
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(userLatitude, userLongitude);
      print("Home: Placemarks: $placemarks");

      return "${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}";
    } catch (e) {
      print("Home: Error in getHumanReadable(): $e");
      return "Gagal mengambil lokasi.";
    }
  }
}
