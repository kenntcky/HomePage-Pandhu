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

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'gempa.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE gempa(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal TEXT,
            jam TEXT,
            lintang TEXT,
            bujur TEXT,
            magnitude TEXT,
            kedalaman TEXT,
            coordinates TEXT,
            status TEXT,
            wilayah TEXT,
            jenisGempa TEXT,
            tsunamiPotensial TEXT,
            infoTambahan TEXT,
            kabupaten TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getLatestGempa() async {
    final db = await database;

    // Query to get the latest entry from the gempa table, ordered by id in descending order
    return await db.query(
      'gempa',
      orderBy: 'id DESC', // Order by id descending (most recent first)
      limit: 1, // Get only the latest entry
    );
  }

  Future<void> insertGempa(Map<String, dynamic> gempaData) async {
    final db = await database;
    await db.insert('gempa', gempaData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllGempa() async {
    final db = await database;
    return await db.query('gempa');
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete('gempa');
  }
}


