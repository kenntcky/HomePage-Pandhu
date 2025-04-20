import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const _themePrefKey = 'theme_mode';
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs; // Default to light

  ThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themePrefKey);
      if (themeIndex != null && themeIndex < ThemeMode.values.length) {
        _themeMode.value = ThemeMode.values[themeIndex];
      } else {
         // Default to light if no preference or invalid value saved
         _themeMode.value = ThemeMode.light;
         await _saveThemeMode(ThemeMode.light); // Save default if not set
      }
    } catch (e) {
      print("Error loading theme mode: $e");
       _themeMode.value = ThemeMode.light; // Fallback to light on error
    }
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
     try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_themePrefKey, mode.index);
     } catch (e) {
        print("Error saving theme mode: $e");
     }
  }

  void toggleTheme() {
    final newMode = _themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _themeMode.value = newMode;
    _saveThemeMode(newMode);
  }

  // Optional: Method to explicitly set theme
  void setThemeMode(ThemeMode mode) {
     _themeMode.value = mode;
     _saveThemeMode(mode);
  }
} 