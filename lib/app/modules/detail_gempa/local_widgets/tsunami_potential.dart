// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TsunamiPotential extends StatelessWidget {
  final String potensi;

  const TsunamiPotential({
    super.key,
    required this.potensi,
  });

  bool _hasTsunamiPotential() {
    return potensi.toLowerCase().contains('tsunami');
  }

  @override
  Widget build(BuildContext context) {
    final bool isTsunamiPotential = _hasTsunamiPotential();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: 210,
      height: 38,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: isTsunamiPotential ? const Color(0xFFF6643C) : const Color(0xFF99D65C),
          ),
          borderRadius: BorderRadius.circular(12),
        )
      ),
      child: Text(
        isTsunamiPotential ? 'Berpotensi tsunami' : 'Tidak berpotensi tsunami',
        style: TextStyle(
          color: isTsunamiPotential ? const Color(0xFFF6643C) : const Color(0xFF99D65C),
          fontSize: 14,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}