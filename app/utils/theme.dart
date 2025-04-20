import 'package:flutter/material.dart';

// Define Colors
const Color lightBackground = Color(0xFFF8F8F8);
const Color lightSurface = Color(0xFFFFFFFF);
const Color darkBackground = Color(0xFF222121); // Darker tone
const Color darkSurface = Color(0xFF3F3C39); // Slightly lighter dark tone
const Color primaryColor = Colors.teal; // Example primary color

// Light Theme
final ThemeData lightThemeData = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: lightBackground,
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: primaryColor, // Often same as primary
    background: lightBackground,
    surface: lightSurface,
    onBackground: Colors.black, // Text/icons on background
    onSurface: Colors.black,    // Text/icons on surface (cards, dialogs)
    onError: Colors.white,    // Text/icons on error backgrounds
    error: Colors.redAccent,  // Error color
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: lightSurface,
    foregroundColor: Colors.black, // Title, icons
    elevation: 1, // Slight shadow
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  cardTheme: const CardTheme(
    color: lightSurface,
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
  // Add other widget themes if needed (ButtonTheme, InputDecorations, etc.)
);

// Dark Theme
final ThemeData darkThemeData = ThemeData.dark().copyWith(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    secondary: primaryColor, // Often same as primary
    background: darkBackground,
    surface: darkSurface,
    onBackground: Colors.white, // Text/icons on background
    onSurface: Colors.white,    // Text/icons on surface (cards, dialogs)
    onError: Colors.black,    // Text/icons on error backgrounds
    error: Colors.red,        // Error color
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: darkSurface,
    foregroundColor: Colors.white, // Title, icons
    elevation: 1,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  cardTheme: const CardTheme(
    color: darkSurface,
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),
   textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  // Add other widget themes if needed (ButtonTheme, InputDecorations, etc.)
); 