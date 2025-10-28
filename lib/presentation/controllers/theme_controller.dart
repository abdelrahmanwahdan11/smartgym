import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_initializer.dart';

class ThemeController extends GetxController {
  final Rx<Color> primaryColor = const Color(0xFF00B3A4).obs;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = AppInitializer.prefs;
    final colorValue = prefs.getInt('theme.primary_color');
    final darkMode = prefs.getBool('theme.dark_mode');
    if (colorValue != null) {
      primaryColor.value = Color(colorValue);
    }
    if (darkMode != null) {
      isDarkMode.value = darkMode;
    }
  }

  Future<void> updatePrimaryColor(Color color) async {
    primaryColor.value = color;
    await AppInitializer.prefs.setInt('theme.primary_color', color.value);
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    await AppInitializer.prefs.setBool('theme.dark_mode', value);
  }
}
