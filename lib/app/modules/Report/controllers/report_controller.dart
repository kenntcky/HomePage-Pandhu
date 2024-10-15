import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ReportController extends GetxController {
  // Observable list to store earthquake reports
  var reports = <Map<String, dynamic>>[].obs;

  late Database _db;

  // Initialize the database
  Future<void> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'earthquake_data.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE reports(id INTEGER PRIMARY KEY, location TEXT, magnitude REAL, timestamp TEXT)',
        );
      },
    );
  }

  // Insert new report
  Future<void> insertReport(String location, double magnitude) async {
    final report = {
      'location': location,
      'magnitude': magnitude,
      'timestamp': DateTime.now().toString(),
    };
    await _db.insert('reports', report,
        conflictAlgorithm: ConflictAlgorithm.replace);
    fetchReports(); // Refresh reports after inserting
  }

  // Fetch reports from the database and update the observable list
  Future<void> fetchReports() async {
    final data = await _db.query('reports');
    reports.assignAll(data);
  }

  @override
  void onInit() {
    super.onInit();
    initDatabase().then((_) => fetchReports());
  }
}
