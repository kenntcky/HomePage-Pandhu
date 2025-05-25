// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_pandhu/app/global_widgets/nav_bar.dart';
import 'package:aplikasi_pandhu/app/modules/home/local_widgets/artikel.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/main_artikel_controller.dart';

class MainArtikelView extends GetView<MainArtikelController> {
  const MainArtikelView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // Use theme background color
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Artikel'),
        centerTitle: false,
        backgroundColor: colorScheme.surface,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GridView(
                    scrollDirection: Axis.vertical,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 4/6,
                    ),
                    children: [
                      Artikel(),
                    ]
                  ),
              ),
              SizedBox(height: 75),
            ],
          ),
          Navbar()
        ],
      )
    );
  }
}
