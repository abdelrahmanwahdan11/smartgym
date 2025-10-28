import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local_data/seed_loader.dart';

class AppInitializer {
  static SharedPreferences? _prefs;

  static SharedPreferences get prefs => _prefs!;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await SeedLoader.ensureSeedLoaded();
    await _ensureSeedAccepted();
  }

  static Future<void> _ensureSeedAccepted() async {
    final accepted = prefs.getBool('seed.accepted') ?? false;
    if (!accepted) {
      await prefs.setBool('seed.accepted', true);
    }
  }

  static Future<Map<String, dynamic>> loadJsonAsset(String path) async {
    final raw = await rootBundle.loadString(path);
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
