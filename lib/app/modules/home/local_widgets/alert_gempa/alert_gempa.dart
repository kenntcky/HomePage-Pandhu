// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:aplikasi_pandhu/app/modules/home/controllers/home_controller.dart';

class AlertGempa extends GetView<HomeController> {
  const AlertGempa({super.key});

  Widget _buildAlertWidget(Map<String, dynamic> gempa) {
    if (gempa.isEmpty) return const SizedBox.shrink();
    
    final DateTime notificationTime = DateTime.tryParse(gempa['notificationTime'] ?? '') ?? 
                                    DateTime.tryParse(gempa['dateTime'] ?? '') ?? 
                                    DateTime.now();
    final DateTime now = DateTime.now();
    final difference = now.difference(notificationTime);
    
    if (difference.inMinutes > 5) return const Standby();
    
    final double distance = double.tryParse(gempa['jarak']?.toString().replaceAll(' km', '') ?? '') ?? 0;
    final String location = gempa['wilayah'] ?? '';
    
    if (distance <= 25) {
      return RedAlert(distance: '${distance.toStringAsFixed(1)} km', location: location);
    } else if (distance <= 50) {
      return YellowAlert(distance: '${distance.toStringAsFixed(1)} km', location: location);
    } else {
      print('notificationTime: ${gempa['notificationTime']}');
      return GreenAlert(distance: '${distance.toStringAsFixed(1)} km', location: location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildAlertWidget(controller.latestEarthquake.value));
  }
}

// Base class for Alert Widgets to share theme logic
abstract class BaseAlertWidget extends StatelessWidget {
  final String distance;
  final String location;

  const BaseAlertWidget({super.key, required this.distance, required this.location});

  Color getAlertColor(BuildContext context);
  Color getTextColor(BuildContext context);
  Color getSubtextColor(BuildContext context);
  String getTitle();
  String getImagePath();
  String getMessage() => 'Hati-hati, gempa sedang terjadi $distance dari anda. $location';
  bool get showSelengkapnya => false; // Default to false

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color alertColor = getAlertColor(context);
    final Color textColor = getTextColor(context);
    final Color subtextColor = getSubtextColor(context);

    Widget alertContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity, // Use max width
        // height: 201, // Let height adjust or set a minHeight?
        constraints: BoxConstraints(minHeight: 180), // Example min height
        decoration: ShapeDecoration(
          color: alertColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: [
            BoxShadow(
              color: alertColor.withOpacity(0.6),
              blurRadius: 15,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3, // Give more space to text
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTitle(),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          getMessage(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: subtextColor,
                            fontSize: 14,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    if (showSelengkapnya)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0), // Add padding if shown
                        child: Text(
                          'Selengkapnya',
                          style: TextStyle(
                            color: textColor, // Use main text color
                            fontSize: 14,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 2, // Give less space to image
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    getImagePath(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Add GestureDetector only for RedAlert
    if (this is RedAlert) {
        return GestureDetector(
          onTap: () => Get.toNamed(Routes.WARNING),
          child: alertContent,
        );
    } else {
        return alertContent;
    }
  }
}

class RedAlert extends BaseAlertWidget {
  const RedAlert({
    super.key,
    required super.distance,
    required super.location,
  });

  @override
  Color getAlertColor(BuildContext context) => const Color(0xFFF6643C); // Reverted to hardcoded red
  @override
  Color getTextColor(BuildContext context) => Colors.white; // Reverted to hardcoded white
  @override
  Color getSubtextColor(BuildContext context) => const Color(0xFFFBC1B1); // Reverted to hardcoded light red
  @override
  String getTitle() => 'Gempa Sedang Terjadi';
  @override
  String getImagePath() => "asset/img/image/gempa.png";
   @override
  bool get showSelengkapnya => true;
}

class YellowAlert extends BaseAlertWidget {
  const YellowAlert({
    super.key,
    required super.distance,
    required super.location,
  });

  @override
  Color getAlertColor(BuildContext context) => const Color(0xFFF1D900); // Reverted to hardcoded yellow
  @override
  Color getTextColor(BuildContext context) => Colors.black; // Reverted to hardcoded black
  @override
  Color getSubtextColor(BuildContext context) => Colors.black.withOpacity(0.7); // Reverted to hardcoded dark grey
  @override
  String getTitle() => 'Gempa Terjadi di Sekitar'; // Slightly different title maybe?
  @override
  String getImagePath() => "asset/img/image/gempa.png";
}

class GreenAlert extends BaseAlertWidget {
  const GreenAlert({
    super.key,
    required super.distance,
    required super.location,
  });

 @override
  Color getAlertColor(BuildContext context) => const Color(0xFF8BD73F); // Reverted to hardcoded green
  @override
  Color getTextColor(BuildContext context) => Colors.white; // Reverted to hardcoded white
  @override
  Color getSubtextColor(BuildContext context) => const Color(0xFFD1EFB2); // Reverted to hardcoded light green
  @override
  String getTitle() => 'Aman! Gempa Jauh'; // Different title
  @override
  String getImagePath() => "asset/img/image/gempa.png"; // Reverted to existing image
}

// Standby widget (reverting to fixed green)
class Standby extends StatelessWidget {
  const Standby({super.key});

  @override
  Widget build(BuildContext context) {
    // Reverted: No longer using theme
    // final ThemeData theme = Theme.of(context);
    // final ColorScheme colorScheme = theme.colorScheme;

    // Hardcoded colors for Standby (matching original GreenAlert appearance)
    const Color alertColor = Color(0xFF8BD73F);
    const Color textColor = Colors.white;
    const Color subtextColor = Color(0xFFD1EFB2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 180),
        decoration: ShapeDecoration(
          color: alertColor, // Use hardcoded green
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
           shadows: [
            BoxShadow(
              color: alertColor.withOpacity(0.6), // Use hardcoded green for shadow
              blurRadius: 15, // Keep blur consistent?
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kondisi Aman',
                      style: TextStyle(
                        color: textColor, // Use hardcoded white
                        fontSize: 20,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Tidak ada gempa terdeteksi di sekitar Anda saat ini.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: subtextColor, // Use hardcoded light green
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    "asset/img/image/gempa.png", // Reverted to existing image
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}