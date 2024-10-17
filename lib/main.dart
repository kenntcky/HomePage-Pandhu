import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

// WorkManager callback dispatcher
@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: $task");

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("Firebase Initialized");
    } catch (e) {
      print('Firebase already initialized: $e');
    }

    readData();

    return Future.value(true);
  });
}

// Function to download the image and convert it to bytes
Future<Uint8List> downloadImageAsBytes(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  return response.bodyBytes; // This gives you the image data in bytes
}


void readData() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  ref.orderByKey().limitToLast(1).onValue.listen((DatabaseEvent event) async {
    final data = event.snapshot.value;
    if (data != null) {
      Map<String, dynamic> dataMap = Map<String, dynamic>.from(data as Map);

      String latestKey = dataMap.keys.first;
      Map<String, dynamic> latestEarthquake =
          Map<String, dynamic>.from(dataMap[latestKey]['Infogempa']['gempa']);

      print("DATA GEMPA TERBARU:");
      print(latestEarthquake["shakemapUrl"]);

      inspect(downloadImageAsBytes(latestEarthquake["shakemapUrl"]));

      // Save data locally to SQLite
      _saveToLocalDatabase(
        tanggal: latestEarthquake["Tanggal"],
        jam: latestEarthquake["Jam"],
        coordinates: latestEarthquake["Coordinates"],
        lintang: latestEarthquake["Lintang"],
        bujur: latestEarthquake["Bujur"],
        magnitude: latestEarthquake["Magnitude"],
        kedalaman: latestEarthquake["Kedalaman"],
        wilayah: latestEarthquake["Wilayah"],
        potensi: latestEarthquake["Potensi"],
        dirasakan: latestEarthquake["Dirasakan"],
        shakemap: await downloadImageAsBytes(latestEarthquake["shakemapUrl"])
      );
    }
  });
}

// Function to open and create SQLite database
Future<Database> _openDatabase() async {
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'dataGempa.db');

  Database db = await openDatabase(
    dbPath,
    version: 1
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
    required Uint8List shakemap}) async {
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
    'shakemap': shakemap
  });

  print("Data saved to SQLite");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initDatabase();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cancel any existing tasks before registering a new one
  await Workmanager().cancelAll();

  // Initialize WorkManager
  readData();
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerOneOffTask("task-identifier", "simpleTask");

  print(await DatabaseHelper().getAllGempa());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
