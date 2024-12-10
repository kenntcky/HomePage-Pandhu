import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../../database.dart';
import '../../../../utils/connectivity_utils.dart';
import 'dart:async';
import '../../../../main.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> gempaList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> gempaNearestList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isOnline = true.obs;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final dbHelper = DatabaseHelper();

  // Add observable for latest earthquake
  final Rx<Map<String, dynamic>> latestEarthquake = Rx<Map<String, dynamic>>({});
  
  // Add timer for periodic checks
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Initial check
    checkLatestEarthquake();
    // Set up periodic check every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      checkLatestEarthquake();
    });
    loadData();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
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
      print('Home: Starting Firebase data fetch');
      // For regular list, keep limit to 25
      final event = await _databaseRef.orderByKey().limitToLast(25).once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        print('Home: Retrieved ${data.length} records from Firebase');
        List<Map<String, dynamic>> earthquakes = [];

        for (var entry in data.entries.toList()) {
          final earthquakeData = await _processEarthquakeData(entry);
          if (earthquakeData != null) {
            earthquakes.add(earthquakeData);
          }
        }

        // Sort by DateTime
        earthquakes.sort((a, b) {
          final aDateTime = DateTime.parse(a['dateTime']);
          final bDateTime = DateTime.parse(b['dateTime']);
          return bDateTime.compareTo(aDateTime);
        });

        // Sync first 10 earthquakes to SQLite
        await dbHelper.syncFromFirebase(earthquakes.take(10).toList());
        gempaList.value = earthquakes;
        
        // Load nearest earthquakes separately
        await _loadNearestEarthquakes();
      }
    } catch (e) {
      print('Home: Error fetching from Firebase: $e');
      throw e;
    }
  }

  Future<void> _loadNearestEarthquakes() async {
    try {
      print('Home: Starting nearest earthquakes fetch');
      // Get all earthquakes without limit
      final event = await _databaseRef.orderByKey().once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        List<Map<String, dynamic>> allEarthquakes = [];

        for (var entry in data.entries.toList()) {
          final earthquakeData = await _processEarthquakeData(entry);
          if (earthquakeData != null) {
            allEarthquakes.add(earthquakeData);
          }
        }

        // Sort by distance
        allEarthquakes.sort((a, b) {
          final distanceA = double.tryParse(a['jarak'].toString()) ?? double.infinity;
          final distanceB = double.tryParse(b['jarak'].toString()) ?? double.infinity;
          return distanceA.compareTo(distanceB);
        });

        // Get only earthquakes within 100km
        List<Map<String, dynamic>> nearestQuakes = allEarthquakes
            .where((quake) => (double.tryParse(quake['jarak'].toString()) ?? double.infinity) < 100)
            .toList();

        // Take only the first 10 and sort by datetime
        nearestQuakes = nearestQuakes.take(10).toList()
          ..sort((a, b) {
            final aDateTime = DateTime.parse(a['dateTime']);
            final bDateTime = DateTime.parse(b['dateTime']);
            return bDateTime.compareTo(aDateTime);
          });

        gempaNearestList.value = nearestQuakes;
        print('Home: Found ${nearestQuakes.length} nearby earthquakes in Firebase data');
      }
    } catch (e) {
      print('Home: Error fetching nearest earthquakes: $e');
      throw e;
    }
  }

  // Helper method to process earthquake data
  Future<Map<String, dynamic>?> _processEarthquakeData(MapEntry entry) async {
    try {
      final value = entry.value;
      if (value['Infogempa']?['gempa']?['Coordinates'] != null) {
        final gempaData = value['Infogempa']['gempa'];
        List<String> parts = gempaData['Coordinates'].split(',');
        var gempaCoordinates = List<double>.filled(2, 0);

        if (parts.length == 2) {
          gempaCoordinates[0] = double.parse(parts[0].trim());
          gempaCoordinates[1] = double.parse(parts[1].trim());
        }

        final jarak = await calculateDistance(gempaCoordinates[0], gempaCoordinates[1]);
        return {
          'tanggal': gempaData['Tanggal'],
          'jam': gempaData['Jam'],
          'coordinates': gempaData['Coordinates'],
          'jarak': jarak,
          'magnitude': gempaData['Magnitude'],
          'kedalaman': gempaData['Kedalaman'],
          'wilayah': gempaData['Wilayah'],
          'potensi': gempaData['Potensi'],
          'dirasakan': gempaData['Dirasakan'],
          'shakemap': gempaData['Shakemap'],
          'dateTime': gempaData['DateTime'],
          'notificationTime': gempaData['notificationTime'] ?? DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      print('Home: Error processing earthquake data: $e');
    }
    return null;
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

  Future<void> checkLatestEarthquake() async {
    print('Checking latest earthquake from Firebase...');
    try {
      final event = await _databaseRef.orderByKey().limitToLast(1).once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final entry = data.entries.first;
        
        if (entry.value['Infogempa']?['gempa']?['Coordinates'] != null) {
          final earthquakeData = await _processEarthquakeData(entry);
          if (earthquakeData != null) {
            print('Latest earthquake data from Firebase: $earthquakeData');
            latestEarthquake.value = earthquakeData;
          }
        }
      }
    } catch (e) {
      print('Error checking latest earthquake: $e');
      // Fallback to SQLite if Firebase fails
      final dbHelper = DatabaseHelper();
      final latest = await dbHelper.getLatestGempa();
      if (latest.isNotEmpty) {
        latestEarthquake.value = latest.first;
      }
    }
  }
}
