import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/posko_controller.dart';
import 'package:aplikasi_pandhu/app/data/models/posko_model.dart';

class ManagePoskoView extends GetView<PoskoController> {
  const ManagePoskoView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Data Posko'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchPoskos(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Posko',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (controller.isError.value) {
                  return Center(child: Text('Error: ${controller.errorMessage.value}'));
                }
                
                if (controller.poskos.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada data posko tersedia. Silakan tambahkan data sampel.'),
                  );
                }
                
                return ListView.builder(
                  itemCount: controller.poskos.length,
                  itemBuilder: (context, index) {
                    final posko = controller.poskos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          posko.alamat,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(posko.lokasi),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              posko.isOpen24Hours ? Icons.access_time : Icons.access_time_filled,
                              color: posko.isOpen24Hours ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                        onTap: () {
                          controller.selectedPosko.value = posko;
                          Get.back();
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
} 