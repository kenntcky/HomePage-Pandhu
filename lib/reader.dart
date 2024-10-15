import 'package:flutter/material.dart';
import 'database.dart';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  Map<String, dynamic> gempaData = {};

  // Initialize the database helper
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    readDataFromSQLite(); // Call the function to fetch data from SQLite when the widget is initialized
  }

  // Fetch latest earthquake data from SQLite
  void readDataFromSQLite() async {
    // Get the latest earthquake data (assuming you want the most recent entry based on the 'id')
    List<Map<String, dynamic>> latestGempa = await dbHelper.getLatestGempa();

    if (latestGempa.isNotEmpty) {
      // Extract the first (latest) entry
      Map<String, dynamic> latestEarthquake = latestGempa.first;

      // Update the UI
      setState(() {
        gempaData = latestEarthquake;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Earthquake Data'),
      ),
      body: gempaData.isNotEmpty
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tanggal: ${gempaData['tanggal']}'),
          Text('Jam: ${gempaData['jam']}'),
          Text('Magnitude: ${gempaData['magnitude']}'),
          Text('Wilayah: ${gempaData['wilayah']}'),
          // Add more fields as necessary
        ],
      )
          : Center(
        child: Text('No data available'),
      ),
    );
  }
}
