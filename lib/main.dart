import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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

    // Open SQLite database
    Database db = await _openDatabase();

    // Fetch data from SQLite
    List<Map<String, dynamic>> localData = await db.query('earthquake_data');
    if (localData.isNotEmpty) {
      // Sync with Firebase if there is data
      DatabaseReference ref = FirebaseDatabase.instance.ref();

      for (var data in localData) {
        await ref.push().set({
          'Wilayah': data['wilayah'],
          'Coordinates': data['coordinates'],
        });
      }

      print("Data synced with Firebase");
    } else {
      print("No data to sync");
    }

    return Future.value(true);
  });
}

void readData() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  ref.orderByKey().limitToLast(1).onValue.listen((DatabaseEvent event) {
    final data = event.snapshot.value;
    if (data != null) {
      Map<String, dynamic> dataMap = Map<String, dynamic>.from(data as Map);

      String latestKey = dataMap.keys.first;
      Map<String, dynamic> latestEarthquake =
          Map<String, dynamic>.from(dataMap[latestKey]['Infogempa']['gempa']);

      print(latestEarthquake["Wilayah"]);
      print(latestEarthquake["Coordinates"]);

      // Save data locally to SQLite
      _saveToLocalDatabase(
        wilayah: latestEarthquake["Wilayah"],
        coordinates: latestEarthquake["Coordinates"],
      );
    }
  });
}

// Function to open and create SQLite database
Future<Database> _openDatabase() async {
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'earthquake_data.db');

  Database db = await openDatabase(
    dbPath,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE earthquake_data (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          wilayah TEXT,
          coordinates TEXT
        )
      ''');
    },
  );

  return db;
}

// Function to save data into SQLite database
Future<void> _saveToLocalDatabase(
    {required String wilayah, required String coordinates}) async {
  Database db = await _openDatabase();

  // Check the number of existing entries
  List<Map<String, dynamic>> existingData = await db.query('earthquake_data');

  // If there are 10 or more entries, delete the oldest
  if (existingData.length >= 10) {
    // Remove the oldest entry
    await db.delete(
      'earthquake_data',
      where: 'id = ?',
      whereArgs: [existingData.first['id']],
    );
  }

  // Insert new data into SQLite
  await db.insert('earthquake_data', {
    'wilayah': wilayah,
    'coordinates': coordinates,
  });

  print("Data saved to SQLite");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cancel any existing tasks before registering a new one
  await Workmanager().cancelAll();

  // Initialize WorkManager
  readData();
  print("main func");
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerOneOffTask("task-identifier", "simpleTask");

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
