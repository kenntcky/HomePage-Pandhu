// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TsunamiPotential extends StatelessWidget {
  const TsunamiPotential({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    width: 210,
                                    height: 38,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          strokeAlign: BorderSide.strokeAlignCenter,
                                          color: Color(0xFF99D65C),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      )
                                    ),
                                    child: 
                                    Text(
                                      'Tidak berpotensi tsunami',
                                      style: TextStyle(
                                        color: Color(0xFF99D65C),
                                        fontSize: 14,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      ),
                                  );
  }
}