import 'dart:convert';

import '../../data/local_data/local_store.dart';

class ActionLogService {
  ActionLogService(this._store);

  final LocalStore _store;

  static const _key = 'log.actions';
  static const _maxEntries = 300;

  final List<Map<String, dynamic>> _buffer = <Map<String, dynamic>>[];

  Future<void> load() async {
    final raw = _store.getString(_key);
    if (raw == null || raw.isEmpty) {
      return;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        _buffer
          ..clear()
          ..addAll(decoded.whereType<Map<String, dynamic>>());
      }
    } catch (_) {
      // ignore invalid payload
    }
  }

  Future<void> record(String action, {Map<String, dynamic>? meta}) async {
    final entry = <String, dynamic>{
      'action': action,
      'meta': meta ?? const <String, dynamic>{},
      'timestamp': DateTime.now().toIso8601String(),
    };
    _buffer.insert(0, entry);
    if (_buffer.length > _maxEntries) {
      _buffer.removeRange(_maxEntries, _buffer.length);
    }
    await _persist();
  }

  List<Map<String, dynamic>> get entries => List.unmodifiable(_buffer);

  Future<void> clear() async {
    _buffer.clear();
    await _store.remove(_key);
  }

  Future<void> _persist() async {
    final encoded = jsonEncode(_buffer);
    await _store.setString(_key, encoded);
  }
}
