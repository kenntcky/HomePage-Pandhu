// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';


class infosr extends StatelessWidget {

final String satuangempa;
final String icongempa;
final String namabawah;

  const infosr({
    Key? key,
    required this.satuangempa,
    required this.icongempa,
    required this.namabawah
    }) : super(key: key);

  String _processText(String text) {
    const String prefix = "Pusat gempa berada di ";
    String processedText = text;
    
    // Remove prefix if exists
    if (processedText.startsWith(prefix)) {
      processedText = processedText.substring(prefix.length);
    }
    
    // Trim whitespace and capitalize
    processedText = processedText.trim();
    if (processedText.isNotEmpty) {
      processedText = processedText[0].toUpperCase() + processedText.substring(1);
    }
    
    return processedText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          icongempa,
          width: 24,
          height: 24,
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: Text(
            _processText(satuangempa),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          namabawah,
          style: const TextStyle(
            color: Color(0xFF666666),
            fontSize: 12,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}