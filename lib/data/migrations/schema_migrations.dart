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

    if (fromVersion < 5 && currentVersion >= 5) {
      await _migrateToV5(fromVersion: fromVersion);
    }

    if (fromVersion < 8 && currentVersion >= 8) {
      await _migrateToV8(fromVersion: fromVersion);
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

  Future<void> _migrateToV5({required int fromVersion}) async {
    final backup = <String, dynamic>{};
    for (final key in store.getKeys()) {
      if (key.startsWith('backup.')) continue;
      final value = store.getValue(key);
      if (value == null) continue;
      if (value is List<String> ||
          value is String ||
          value is bool ||
          value is int ||
          value is double) {
        backup[key] = value;
      }
    }
    if (backup.isNotEmpty) {
      await store.setString('backup.v4', jsonEncode(backup));
    }

    await store.setStringList('roles.active', store.getStringList('roles.active') ?? ['user']);
    await store.setJson('provider.gyms', store.getJson('provider.gyms') ?? <String, dynamic>{});
    await store.setJson('provider.trainers', store.getJson('provider.trainers') ?? <String, dynamic>{});
    await store.setJson('provider.classes', store.getJson('provider.classes') ?? <String, dynamic>{});
    await store.setJson('provider.products', store.getJson('provider.products') ?? <String, dynamic>{});
    await store.setJson('moderation.queue', store.getJson('moderation.queue') ?? <String, dynamic>{});
    await store.setJson('reports.closed', store.getJson('reports.closed') ?? <String, dynamic>{});
    await store.setString('currency.code', store.getString('currency.code') ?? 'USD');
    await store.setString('currency.fx', store.getString('currency.fx') ?? '1.0');
    await store.setBool('vat.enabled', store.getBool('vat.enabled') ?? true);
    await store.setBool('pin.enabled', store.getBool('pin.enabled') ?? false);
    await store.setString('pin.code_hash', store.getString('pin.code_hash') ?? '');
    await store.setBool('display.arabic_digits', store.getBool('display.arabic_digits') ?? false);
    await store.setBool('units.metric', store.getBool('units.metric') ?? true);
    await store.setJson('saved_filters.classes', store.getJson('saved_filters.classes') ?? <String, dynamic>{});
    await store.setJson('saved_filters.store', store.getJson('saved_filters.store') ?? <String, dynamic>{});
    await store.setJson('saved_searches.classes', store.getJson('saved_searches.classes') ?? <String, dynamic>{});
    await store.setJson('saved_searches.store', store.getJson('saved_searches.store') ?? <String, dynamic>{});
    await store.setBool('safe_mode.enabled', store.getBool('safe_mode.enabled') ?? false);
    await store.setJson('feature_flags.v5', store.getJson('feature_flags.v5') ?? <String, dynamic>{});
    await store.setString('ui.view_mode.classes', store.getString('ui.view_mode.classes') ?? 'list');
    await store.setString('ui.grid_density', store.getString('ui.grid_density') ?? 'comfortable');
    await store.setBool('ui.show_parallax_headers', store.getBool('ui.show_parallax_headers') ?? true);
    await store.setBool('ui.filter_drawer_persistent', store.getBool('ui.filter_drawer_persistent') ?? false);
    await store.setString('ui.theme_preview.last_seed', store.getString('ui.theme_preview.last_seed') ?? '');
    await store.setStringList('ui.favorites.classes', store.getStringList('ui.favorites.classes') ?? <String>[]);
    await store.setStringList('ui.favorites.gyms', store.getStringList('ui.favorites.gyms') ?? <String>[]);
    await store.setStringList('ui.favorites.trainers', store.getStringList('ui.favorites.trainers') ?? <String>[]);

    await store.remove('feature_flags.v3');
    await store.remove('search.index');
    await store.setString('search.synonyms_version', '1');
    if (fromVersion < 5) {
      await store.setString('schema.migrated_from', fromVersion.toString());
    }
  }

  Future<void> _migrateToV8({required int fromVersion}) async {
    final backup = <String, dynamic>{};
    for (final key in store.getKeys()) {
      if (key.startsWith('backup.')) {
        continue;
      }
      final value = store.getValue(key);
      if (value == null) {
        continue;
      }
      if (value is String ||
          value is bool ||
          value is int ||
          value is double ||
          value is List<String>) {
        backup[key] = value;
      }
    }
    if (backup.isNotEmpty) {
      await store.setString('backup.v7', jsonEncode(backup));
    }

    await store.setStringList(
      'ui.favorites.classes',
      store.getStringList('ui.favorites.classes') ?? <String>[],
    );
    await store.setStringList(
      'ui.favorites.gyms',
      store.getStringList('ui.favorites.gyms') ?? <String>[],
    );
    await store.setStringList(
      'ui.favorites.trainers',
      store.getStringList('ui.favorites.trainers') ?? <String>[],
    );

    final fx = double.tryParse(store.getString('currency.fx') ?? '') ?? 1.0;
    await store.setString('currency.fx', fx.toStringAsFixed(4));
    await store.setBool('vat.enabled', store.getBool('vat.enabled') ?? true);
    await store.setBool('prefs.reduce_motion', store.getBool('prefs.reduce_motion') ?? false);
    await store.setBool('prefs.high_contrast', store.getBool('prefs.high_contrast') ?? false);

    await store.remove('feature_flags.v5');
    await store.setJson('feature_flags.v8', store.getJson('feature_flags.v8') ?? <String, dynamic>{});

    await store.remove('search.index');
    await store.setString('schema.last_migration', '8');
    if (fromVersion < 8) {
      await store.setString('schema.migrated_from', fromVersion.toString());
    }
  }
}

Future<void> ensureSchemaVersion({required int targetVersion}) async {
  final prefs = await SharedPreferences.getInstance();
  final store = LocalStore(prefs);
  final migrations = SchemaMigrations(store: store, currentVersion: targetVersion);
  await migrations.run();
}
