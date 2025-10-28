import 'dart:convert';

import 'package:get/get.dart';

import '../../data/local_data/local_store.dart';
import '../../data/models/report_model.dart';

class ModerationService extends GetxService {
  ModerationService(this.store);

  final LocalStore store;

  static const _queueKey = 'moderation.queue';
  static const _closedKey = 'reports.closed';

  final RxList<String> bannedWords = <String>['spam', 'abuse', 'مسيء'].obs;

  Future<void> load() async {
    final savedWords = store.getString('moderation.bad_words');
    if (savedWords != null && savedWords.isNotEmpty) {
      try {
        final decoded = (jsonDecode(savedWords) as List<dynamic>).cast<String>();
        bannedWords
          ..clear()
          ..addAll(decoded);
      } catch (_) {}
    }

    final queueJson = store.getString(_queueKey);
    if (queueJson != null && queueJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(queueJson) as Map<String, dynamic>;
        _queue.assignAll(decoded.values
            .whereType<Map<String, dynamic>>()
            .map(ReportModel.fromMap)
            .toList());
      } catch (_) {}
    }
    final closedJson = store.getString(_closedKey);
    if (closedJson != null && closedJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(closedJson) as Map<String, dynamic>;
        _closed.assignAll(decoded.values
            .whereType<Map<String, dynamic>>()
            .map(ReportModel.fromMap)
            .toList());
      } catch (_) {}
    }
  }

  final RxList<ReportModel> _queue = <ReportModel>[].obs;
  final RxList<ReportModel> _closed = <ReportModel>[].obs;

  List<ReportModel> get queue => _queue;
  List<ReportModel> get closed => _closed;

  bool containsFlaggedWords(String text) {
    final lower = text.toLowerCase();
    return bannedWords.any((word) => lower.contains(word.toLowerCase()));
  }

  Future<ReportModel> submitReport({required String postId, required String reason}) async {
    final report = ReportModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: postId,
      reason: reason,
      date: DateTime.now(),
    );
    _queue.add(report);
    await _persist();
    return report;
  }

  Future<void> resolve(String id, String status) async {
    final index = _queue.indexWhere((element) => element.id == id);
    if (index == -1) return;
    final report = _queue.removeAt(index).copyWith(status: status);
    _closed.add(report);
    await _persist();
  }

  Future<void> _persist() async {
    await store.setString(
      _queueKey,
      jsonEncode({for (final r in _queue) r.id: r.toMap()}),
    );
    await store.setString(
      _closedKey,
      jsonEncode({for (final r in _closed) r.id: r.toMap()}),
    );
  }

  Future<void> updateBannedWords(List<String> words) async {
    bannedWords
      ..clear()
      ..addAll(words);
    await store.setString('moderation.bad_words', jsonEncode(words));
  }
}
