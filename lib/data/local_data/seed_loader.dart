import 'dart:convert';

import 'package:flutter/services.dart';

class SeedLoader {
  static final Map<String, dynamic> _cache = {};

  static Future<void> ensureSeedLoaded() async {
    await Future.wait([
      _load('assets/data/gyms.json'),
      _load('assets/data/classes.json'),
      _load('assets/data/trainers.json'),
      _load('assets/data/products.json'),
      _load('assets/data/subscriptions.json'),
      _load('assets/data/achievements.json'),
      _load('assets/data/users.json'),
    ]);
  }

  static Future<Map<String, dynamic>> _load(String path) async {
    if (_cache.containsKey(path)) {
      return _cache[path] as Map<String, dynamic>;
    }
    final raw = await rootBundle.loadString(path);
    final data = jsonDecode(raw) as Map<String, dynamic>;
    _cache[path] = data;
    return data;
  }

  static Map<String, dynamic>? tryGet(String path) {
    return _cache[path] as Map<String, dynamic>?;
  }
}
