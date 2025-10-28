import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../local_data/local_store.dart';

class SchemaMigrations {
  SchemaMigrations({required this.store, required this.currentVersion});

  final LocalStore store;
  final int currentVersion;

  static const String versionKey = 'schema.version';

  Future<void> run() async {
    final storedVersion = store.getString(versionKey);
    final parsed = int.tryParse(storedVersion ?? '');
    final fromVersion = parsed ?? 0;
    if (fromVersion >= currentVersion) {
      return;
    }

    if (fromVersion < 4 && currentVersion >= 4) {
      await _migrateToV4();
    }

    await store.setString(versionKey, currentVersion.toString());
  }

  Future<void> _migrateToV4() async {
    await store.setBool('prefs.reduce_motion', store.getBool('prefs.reduce_motion') ?? false);
    await store.setBool('prefs.high_contrast', store.getBool('prefs.high_contrast') ?? false);
    await store.setBool('ui.performance_overlay', store.getBool('ui.performance_overlay') ?? false);

    final rawReviews = store.getString('reviews.local');
    if (rawReviews != null && rawReviews.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawReviews);
        if (decoded is Map<String, dynamic>) {
          final updated = <String, dynamic>{};
          decoded.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              final reviews = value['reviews'];
              if (reviews is List) {
                final stars = reviews
                    .whereType<Map<String, dynamic>>()
                    .map((e) => (e['stars'] as num?)?.toDouble() ?? 0)
                    .where((element) => element > 0)
                    .toList();
                if (stars.isNotEmpty) {
                  final avg = stars.reduce((a, b) => a + b) / stars.length;
                  updated[key] = {...value, 'avg_rating': avg};
                } else {
                  updated[key] = value;
                }
              } else {
                updated[key] = value;
              }
            }
          });
          if (updated.isNotEmpty) {
            await store.setString('reviews.local', jsonEncode(updated));
          }
        }
      } catch (_) {
        // Ignore malformed payloads.
      }
    }

    await store.remove('search.index');
  }
}

Future<void> ensureSchemaVersion({required int targetVersion}) async {
  final prefs = await SharedPreferences.getInstance();
  final store = LocalStore(prefs);
  final migrations = SchemaMigrations(store: store, currentVersion: targetVersion);
  await migrations.run();
}
