  // lib/database_helper.dart
  import 'package:sqflite/sqflite.dart';
  import 'package:path/path.dart';
  import 'package:shared_preferences/shared_preferences.dart';

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
      final prefs = await SharedPreferences.getInstance();
      bool isDatabaseInitialized = prefs.getBool('dbInitialized') ?? false;
      String path = join(await getDatabasesPath(), 'dataGempa.db');

      if (!isDatabaseInitialized){
        await prefs.setBool('dbInitialized', true);
        return await openDatabase(
        path,
        version: 1,
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
              tsunamiPotensial INTEGER,
              kabupaten TEXT
            )
          ''');
        },
      );
      } else {
        return await openDatabase(path);
      }
    }

    Future<List<Map<String, dynamic>>> getLatestGempa() async {
      final db = await database;

      print("Hello");

      // Query to get the latest entry from the gempa table, ordered by id in descending order
      return await db.query(
        'dataGempa',
        orderBy: 'id DESC', // Order by id descending (most recent first)
        limit: 1, // Get only the latest entry
      );
    }

    Future<void> insertGempa(Map<String, dynamic> gempaData) async {
      final db = await database;
      await db.insert('dataGempa', gempaData,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<List<Map<String, dynamic>>> getAllGempa() async {
      final db = await database;
      return await db.query('dataGempa');
    }

    Future<void> deleteAll() async {
      final db = await database;
      await db.delete('dataGempa');
    }
  }
