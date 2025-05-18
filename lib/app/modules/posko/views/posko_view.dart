import 'package:aplikasi_pandhu/app/modules/posko/local_widgets/detail_posko.dart';
import 'package:aplikasi_pandhu/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/posko_controller.dart';

class PoskoView extends GetView<PoskoController> {
  const PoskoView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posko Gempa'),
        centerTitle: true,
      ),
      body: DraggableScrollableSheet(
            initialChildSize: 0.37,
            minChildSize: 0.37,
            maxChildSize: 0.65,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  // Removed background color to make sheet transparent
                  // color: colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag indicator
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        // Use a less prominent theme color
                        color: colorScheme.onSurface.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // Scrollable content
                    Flexible(  // Changed from Expanded to Flexible
                      child: ClipRRect(  // Added ClipRRect to clip content
                        child: SingleChildScrollView(
                          controller: scrollController,
                          clipBehavior: Clip.none,  // Prevent scrolling content from showing outside bounds
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),  // Removed padding bottom
                            child: Column(
                              children: [
                                Container(
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: colorScheme.surface, 
                                    // Removed the border property
                                    // border: Border.all(color: colorScheme.outlineVariant ?? colorScheme.onSurface.withOpacity(0.12), width: 1)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Perumahan Permata Puri, Jl. Bukit Barisan Blok AIV No. 9, Bringin, Ngaliyan.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: colorScheme.onBackground,
                                            fontSize: 16,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text('Kota Semarang, 50189',
                                        style: TextStyle(
                                              color: colorScheme.onBackground.withOpacity(0.6),
                                              fontSize: 12,
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                        ),
                                        IntrinsicWidth(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            height: 38,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1,
                                                  strokeAlign: BorderSide.strokeAlignCenter,
                                                  color: const Color(0xFF99D65C),
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                              )
                                            ),
                                            child: Center(
                                              child: Text('BUKA 24 JAM',
                                                style: TextStyle(
                                                  color: const Color(0xFF99D65C),
                                                  fontSize: 14,
                                                  fontFamily: 'Plus Jakarta Sans',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Your second container
                                Container(
                                  height: 195,
                                  decoration: BoxDecoration(
                                    // Use surface color for this container background
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(24)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DetailPosko(
                                          headline: 'Telepon', 
                                          detailicon: 'asset/img/icon/clock.png', 
                                          detaildata: '(024) 7628345 (08:00 - 16:00) / 115'
                                        ),
                                        DetailPosko(
                                          headline: 'Instagram', 
                                          detailicon: 'asset/img/icon/coordinate.png', 
                                          detaildata: 'basarnas_jateng'
                                        ),
                                        DetailPosko(
                                          headline: 'Email', 
                                          detailicon: 'asset/img/icon/distance.png', 
                                          detaildata: 'sar.semarang@basarnas.go.id'
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Fixed button at bottom
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        // color: Colors.white,
                        border: Border(
                          // top: BorderSide(
                          //   color: Colors.grey,
                          //   width: 0.5,
                          // ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.ARTIKEL);
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6643C),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Lebih lanjut',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Image.asset(
                                "asset/img/icon/arrow-right-white.png",
                                width: 24,
                                height: 24,
                                fit: BoxFit.fill,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
