  // lib/database_helper.dart
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'dart:math' show min;

  class DatabaseHelper {
    static final DatabaseHelper _instance = DatabaseHelper._internal();
    factory DatabaseHelper() => _instance;

    static Database? _database;

    DatabaseHelper._internal();

    Future<Database> get database async {
      if (_database != null) return _database!;

      print("Hello");

      _database = await initDatabase();
      return _database!;
    }

    Future<Database> initDatabase() async {
      String path = join(await getDatabasesPath(), 'dataGempa.db');

      return await openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE dataGempa(
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
              jarak REAL,
              tsunamiPotensial INTEGER,
              kabupaten TEXT,
              dateTime TEXT,
              notificationTime TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE dataGempaTerdekat(
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
              jarak REAL,
              tsunamiPotensial INTEGER,
              kabupaten TEXT,
              dateTime TEXT,
              notificationTime TEXT
            )
          ''');
        }
      );
    }

    Future<List<Map<String, dynamic>>> getLatestGempa() async {
      final db = await database;
      return await db.query(
        'dataGempa',
        orderBy: 'notificationTime DESC',
        limit: 1,
      );
    }

    Future<void> insertGempa(Map<String, dynamic> gempaData) async {
      final db = await database;
      await db.insert('dataGempa', gempaData,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<List<Map<String, dynamic>>> getAllGempa() async {
      try {
        final db = await database;
        final results = await db.query(
          'dataGempa', 
          orderBy: 'notificationTime DESC'
        );
        return results;
      } catch (e) {
        print('Error fetching data: $e');
        return [];
      }
    }

    Future<List<Map<String, dynamic>>> getAllGempaNearest() async {
      try {
        final db = await database;
        final results = await db.query('dataGempaTerdekat', orderBy: 'id DESC');
        return results;
      } catch (e) {
        print('Error fetching nearest data: $e');
        return [];
      }
    }

    Future<void> deleteAll() async {
      final db = await database;
      await db.delete('dataGempa');
    }

    Future<void> syncFromFirebase(List<Map<String, dynamic>> firebaseData) async {
      final db = await database;
      await db.transaction((txn) async {
        // Clear existing data
        await txn.delete('dataGempa');
        
        // Insert new data (limited to 10 entries)
        for (var i = 0; i < min(10, firebaseData.length); i++) {
          var data = firebaseData[i];
          
          // Download and store shakemap
          String? shakemapUrl;
          if (data['shakemap'] != null) {
            shakemapUrl = 'https://data.bmkg.go.id/DataMKG/TEWS/${data['shakemap']}';
          }
          
          Uint8List? shakemapBytes;
          if (shakemapUrl != null) {
            try {
              final response = await http.get(Uri.parse(shakemapUrl));
              if (response.statusCode == 200) {
                shakemapBytes = response.bodyBytes;
              }
            } catch (e) {
              print('Error downloading shakemap: $e');
            }
          }
          
          await txn.insert('dataGempa', {
            ...data,
            'shakemap': shakemapBytes,
            'notificationTime': data['notificationTime'] ?? DateTime.now().toIso8601String(),
          });
        }
      });
    }
  }
