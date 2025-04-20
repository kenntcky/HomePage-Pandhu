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
    // Get theme and color scheme
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

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
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          namabawah,
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 12,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}