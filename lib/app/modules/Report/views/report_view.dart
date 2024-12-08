// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earthquake Reports'),
      ),
      body: Obx(() {
        // Reactively update the UI when the reports list changes
        if (controller.reports.isEmpty) {
          return Center(child: Text('No reports yet.'));
        }

        return ListView.builder(
          itemCount: controller.reports.length,
          itemBuilder: (context, index) {
            final report = controller.reports[index];
            return ListTile(
              title: Text(report['location']),
              subtitle: Text(
                  'Magnitude: ${report['magnitude']} | Time: ${report['timestamp']}'),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Insert a new report when button is pressed
          controller.insertReport('Jakarta', 5.5);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
