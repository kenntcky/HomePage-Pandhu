  // lib/database_helper.dart
  import 'package:sqflite/sqflite.dart';
  import 'package:path/path.dart';

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
              jarak REAL,
              tsunamiPotensial INTEGER,
              kabupaten TEXT
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
              kabupaten TEXT
            )
          ''');
        },
      );
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
      try {
        final db = await database;
        final results = await db.query('dataGempa', orderBy: 'id DESC');
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
  }
