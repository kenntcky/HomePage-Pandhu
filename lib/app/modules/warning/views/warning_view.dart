import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/warning_controller.dart';

class WarningView extends GetView<WarningController> {
  const WarningView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WarningView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WarningView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
