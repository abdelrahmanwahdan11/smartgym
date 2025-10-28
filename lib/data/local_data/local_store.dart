import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight abstraction over [SharedPreferences] that provides
/// safe JSON helpers and guards against oversized payloads.
class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferences _prefs;

  static const int _maxStringBytes = 200 * 1024; // 200KB safety limit.

  String? getString(String key) => _prefs.getString(key);

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<bool> setString(String key, String value) async {
    if (utf8.encode(value).length > _maxStringBytes) {
      return false;
    }
    return _prefs.setString(key, value);
  }

  Map<String, dynamic>? getJson(String key) {
    final raw = getString(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<bool> setJson(String key, Map<String, dynamic> value) {
    final encoded = jsonEncode(value);
    return setString(key, encoded);
  }

  Future<bool> remove(String key) => _prefs.remove(key);

  bool containsKey(String key) => _prefs.containsKey(key);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<bool> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);

  Object? getValue(String key) => _prefs.get(key);

  Set<String> getKeys() => _prefs.getKeys();

  Future<bool> clearKeys(Iterable<String> keys) async {
    var result = true;
    for (final key in keys) {
      final success = await _prefs.remove(key);
      result = result && success;
    }
    return result;
  }
}
