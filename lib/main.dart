import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// WorkManager callback dispatcher
@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: $task");

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("rispek");
    } catch (e) {
      print('Firebase already initialized: $e');
    }



    return Future.value(true);
  });
}

void readData() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  ref.orderByKey().limitToLast(1).onValue.listen((DatabaseEvent event) {
    final data = event.snapshot.value;
    if (data != null) {
      // The returned data will be a map where the key is the timestamp
      // and the value is the earthquake data.
      Map<String, dynamic> dataMap = Map<String, dynamic>.from(data as Map);

      // Extract the latest earthquake data
      String latestKey = dataMap.keys.first;
      Map<String, dynamic> latestEarthquake = Map<String, dynamic>.from(dataMap[latestKey]['Infogempa']['gempa']);

      print(latestEarthquake);
    }
  });
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
      isInDebugMode: false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
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
