import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/controllers/theme_controller.dart';
import 'app/utils/theme.dart';
import 'app/global_widgets/nav_bar.dart'; // Import NavbarController

// Initialize notifications
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initializeNotifications() {
  final initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher'); // App icon

  final initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

// Function to download the image and convert it to bytes
Future<Uint8List> downloadImageAsBytes(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  return response.bodyBytes; // This gives you the image data in bytes
}

Future<double> calculateDistance(double gempaLat, double gempaLon) async {
  final prefs = await SharedPreferences.getInstance();
  
  double? userLat;
  double? userLon;
  
  // Keep checking every 1500 milliseconds until values are found (with a max limit)
  int maxAttempts = 10; // For example, it will retry 10 times (5 seconds total)
  int attempts = 0;

  while (userLat == null || userLon == null) {
    userLat = prefs.getDouble('userLat');
    userLon = prefs.getDouble('userLon');

    if (userLat != null && userLon != null) {
      break;
    }

    if (attempts >= maxAttempts) {
      return 0.0;
    }

    // Wait for 500 milliseconds before checking again
    await Future.delayed(Duration(milliseconds: 1500));
    attempts++;
  }

  // Haversine formula to calculate the distance between two points
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((gempaLat - userLat) * p) / 2 +
      c(userLat * p) * c(gempaLat * p) *
      (1 - c((gempaLon - userLon) * p)) / 2;
  double distance = 12742 * asin(sqrt(a));

  // Round the distance to one decimal place
  return double.parse((distance).toStringAsFixed(1));
}

void readData() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final prefs = await SharedPreferences.getInstance();
  String? lastProcessedKey = prefs.getString('lastProcessedKey');

  ref.orderByKey().limitToLast(10).onValue.listen((DatabaseEvent event) async {
    final data = event.snapshot.value;
    if (data != null) {
      Map<String, dynamic> dataMap = Map<String, dynamic>.from(data as Map);
      
      // Get the latest key
      String latestKey = dataMap.keys.last;
      
      // Only process if this is a new earthquake (different key)
      if (lastProcessedKey != latestKey) {
        for (String key in dataMap.keys) {
          Map<String, dynamic> earthquakeData = Map<String, dynamic>.from(dataMap[key]['Infogempa']['gempa']);
          
          bool exists = await _checkIfDataExists(
            tanggal: earthquakeData["Tanggal"], 
            jam: earthquakeData["Jam"]
          );

          if (!exists) {
            String coordinatesBMKG = earthquakeData['Coordinates'];
            List<String> parts = coordinatesBMKG.split(',');
            var gempaCoordinatesx = List<double>.filled(2, 0);

            if (parts.length == 2) {
              gempaCoordinatesx[0] = double.parse(parts[0].trim());
              gempaCoordinatesx[1] = double.parse(parts[1].trim());
            }

            double jarak = await calculateDistance(gempaCoordinatesx[0], gempaCoordinatesx[1]);
            
            if (jarak < 1000) {
              await _saveToLocalDatabaseNearest(
              tanggal: earthquakeData["Tanggal"],
              jam: earthquakeData["Jam"],
              coordinates: earthquakeData["Coordinates"],
              lintang: earthquakeData["Lintang"],
              bujur: earthquakeData["Bujur"],
              magnitude: earthquakeData["Magnitude"],
              kedalaman: earthquakeData["Kedalaman"],
              wilayah: earthquakeData["Wilayah"],
              potensi: earthquakeData["Potensi"],
              dirasakan: earthquakeData["Dirasakan"],
              shakemap: await downloadImageAsBytes(earthquakeData["shakemapUrl"]),
              jarak: jarak
              );
            } else {
              await _saveToLocalDatabase(
              tanggal: earthquakeData["Tanggal"],
              jam: earthquakeData["Jam"],
              coordinates: earthquakeData["Coordinates"],
              lintang: earthquakeData["Lintang"],
              bujur: earthquakeData["Bujur"],
              magnitude: earthquakeData["Magnitude"],
              kedalaman: earthquakeData["Kedalaman"],
              wilayah: earthquakeData["Wilayah"],
              potensi: earthquakeData["Potensi"],
              dirasakan: earthquakeData["Dirasakan"],
              shakemap: await downloadImageAsBytes(earthquakeData["shakemapUrl"]),
              jarak: jarak
            );
            }
          }
        }

        // Only show notification for new data
        showNotification(Map<String, dynamic>.from(dataMap[latestKey]['Infogempa']['gempa']));
        
        // Save the latest processed key
        await prefs.setString('lastProcessedKey', latestKey);
      }
    }
  });
}

// Function to check if a record already exists in SQLite
Future<bool> _checkIfDataExists({required String tanggal, required String jam}) async {
  Database db = await _openDatabase();

  // Query SQLite to see if this data already exists based on 'tanggal' and 'jam'
  List<Map<String, dynamic>> result = await db.query(
    'dataGempa',
    where: 'tanggal = ? AND jam = ?',
    whereArgs: [tanggal, jam],
  );

  // If the result is not empty, it means the data exists
  return result.isNotEmpty;
}

void showNotification(Map<String, dynamic> latestEarthquake) async {
  final BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
    'Lokasi: ${latestEarthquake["Wilayah"]}\n'
    'Magnitudo: ${latestEarthquake["Magnitude"]}\n'
    'Kedalaman: ${latestEarthquake["Kedalaman"]}\n'
    'Potentsi: ${latestEarthquake["Potensi"]}\n'
    'Dirasakan: ${latestEarthquake["Dirasakan"]}',
    contentTitle: 'Terdeteksi Gempa Baru',
    summaryText: 'Info Gempa Baru',
  );

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'gempa_baru_channel', 'Noifikasi Gempa',
          channelDescription: 'Channel ini digunakan untuk notifikasi gempa baru.',
          styleInformation: bigTextStyleInformation,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',);

  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
    0, // Unique notification ID
    'Gempa ber-magnitudo ${latestEarthquake["Magnitude"]}',
    '${latestEarthquake["Wilayah"]}',
    platformChannelSpecifics,
    payload: 'Detail Gempa',
  );
}
// Function to open and create SQLite database
Future<Database> _openDatabase() async {
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'dataGempa.db');

  Database db = await openDatabase(
    dbPath,
    version: 1,
    onCreate: (Database db, int version) async {
      // Create main earthquake data table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS dataGempa (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tanggal TEXT,
          jam TEXT,
          coordinates TEXT,
          lintang TEXT,
          bujur TEXT,
          magnitude TEXT,
          kedalaman TEXT,
          wilayah TEXT,
          potensi TEXT,
          dirasakan TEXT,
          shakemap BLOB,
          jarak REAL
        )
      ''');
      
      // Create nearest earthquake data table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS dataGempaTerdekat (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tanggal TEXT,
          jam TEXT,
          coordinates TEXT,
          lintang TEXT,
          bujur TEXT,
          magnitude TEXT,
          kedalaman TEXT,
          wilayah TEXT,
          potensi TEXT,
          dirasakan TEXT,
          shakemap BLOB,
          jarak REAL
        )
      ''');
    }
  );

  return db;
}

// Function to save data into SQLite database
Future<void> _saveToLocalDatabase(
    {required String tanggal, 
    required String jam, 
    required String coordinates, 
    required String lintang, 
    required String bujur, 
    required String magnitude, 
    required String kedalaman, 
    required String wilayah, 
    required String potensi, 
    required String dirasakan, 
    required Uint8List shakemap,
    required double jarak}) async {
  Database db = await _openDatabase();

  // Check the number of existing entries
  List<Map<String, dynamic>> existingData = await db.query('dataGempa');

  // If there are 10 or more entries, delete the oldest
  if (existingData.length >= 10) {
    // Remove the oldest entry
    await db.delete(
      'dataGempa',
      where: 'id = ?',
      whereArgs: [existingData.first['id']],
    );
  }

  // Insert new data into SQLite
  await db.insert('dataGempa', {
    'tanggal': tanggal,
    'jam': jam,
    'coordinates': coordinates,
    'lintang': lintang,
    'bujur': bujur,
    'magnitude': magnitude,
    'kedalaman': kedalaman,
    'wilayah': wilayah,
    'potensi': potensi,
    'dirasakan': dirasakan,
    'shakemap': shakemap,
    'jarak': jarak
  });

  print("Data saved to SQLite");
}

// Function to save data into SQLite database
Future<void> _saveToLocalDatabaseNearest(
    {required String tanggal, 
    required String jam, 
    required String coordinates, 
    required String lintang, 
    required String bujur, 
    required String magnitude, 
    required String kedalaman, 
    required String wilayah, 
    required String potensi, 
    required String dirasakan, 
    required Uint8List shakemap,
    required double jarak}) async {
  Database db = await _openDatabase();

  // Check the number of existing entries
  List<Map<String, dynamic>> existingData = await db.query('dataGempaTerdekat');

  // If there are 10 or more entries, delete the oldest
  if (existingData.length >= 10) {
    // Remove the oldest entry
    await db.delete(
      'dataGempaTerdekat',
      where: 'id = ?',
      whereArgs: [existingData.first['id']],
    );
  }

  // Insert new data into SQLite
  await db.insert('dataGempaTerdekat', {
    'tanggal': tanggal,
    'jam': jam,
    'coordinates': coordinates,
    'lintang': lintang,
    'bujur': bujur,
    'magnitude': magnitude,
    'kedalaman': kedalaman,
    'wilayah': wilayah,
    'potensi': potensi,
    'dirasakan': dirasakan,
    'shakemap': shakemap,
    'jarak': jarak
  });

  print("Data saved to SQLite");
}

// Update the isLocationInitialized function
Future<String> determineInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  
  // If user hasn't seen onboarding, show it first
  if (!hasSeenOnboarding) {
    return Routes.ONBOARDING;
  }
  
  // Otherwise, check location initialization
  bool isLocationInitialized = prefs.getBool('locationInitialized') ?? false;
  if (isLocationInitialized) {
    return Routes.HOME;
  } else {
    return Routes.PERMISSION;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env file before anything else
  try {
    await dotenv.load();
  } catch (e) {
    print("Error loading environment: $e");
  }
  
  // Initialize Controllers early
  Get.put(ThemeController());
  Get.put(NavbarController()); // Add NavbarController here

  await DatabaseHelper().initDatabase();
  String initialRoute = await determineInitialRoute(); // Determine initial route

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Ensure Firestore is initialized with settings
    FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Initialize Flutter Local Notifications plugin
    initializeNotifications();

    // Initialize Firebase Messaging
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    // Subscribe to the 'earthquake-updates' topic
    await messaging.subscribeToTopic('earthquake-updates');

    // Start reading data immediately
    readData();
    
    HomeController().getHumanReadable();
    
    runApp(
      GetX<ThemeController>(
        builder: (themeController) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            theme: lightThemeData,
            darkTheme: darkThemeData,
            themeMode: themeController.themeMode,
            initialRoute: initialRoute,
            getPages: AppPages.routes,
            routingCallback: (routing) { // Add routingCallback
              // Update navbar index based on current route
              final String currentRoute = routing?.current ?? '';
              // Use tryFind to avoid errors if controller isn't ready yet
              final NavbarController? navbarController = Get.isRegistered<NavbarController>() 
                                                          ? Get.find<NavbarController>() 
                                                          : null;

              if (navbarController != null) {
                  if (currentRoute == Routes.HOME) {
                    navbarController.changePage(0);
                  } else if (currentRoute == Routes.RIWAYAT) {
                    navbarController.changePage(1);
                  }
                  // Add other main routes here if needed
                  // else {
                  //   // Optional: handle routes not meant to be highlighted by navbar
                  // } 
              }
            },
          );
        }
      ),
    );
  } catch (e) {
    print("Error during initialization: $e");
    // Handle initialization errors appropriately
  }
}
