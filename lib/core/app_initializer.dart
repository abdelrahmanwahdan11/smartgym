import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local_data/local_store.dart';
import '../data/local_data/seed_loader.dart';
import '../data/migrations/schema_migrations.dart';

class AppInitializer {
  static SharedPreferences? _prefs;
  static LocalStore? _store;

  static SharedPreferences get prefs => _prefs!;
  static LocalStore get store => _store!;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _store = LocalStore(_prefs!);
    await SeedLoader.ensureSeedLoaded();
    await _ensureSeedAccepted();
    await ensureSchemaVersion(targetVersion: 5);
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
