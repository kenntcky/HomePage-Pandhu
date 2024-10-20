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
import 'package:shared_preferences/shared_preferences.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

      showNotification(latestEarthquake);
    }
  });
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

  Future<String> isLocationInitialized() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLocationInitialized = prefs.getBool('locationInitialized') ?? false;
    if (isLocationInitialized) {
      return Routes.HOME;
    } else {
      return Routes.PERMISSION;
    }
  }

  HomeController().getHumanReadable();
  
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: await isLocationInitialized(),
      getPages: AppPages.routes
    ),
  );
}
