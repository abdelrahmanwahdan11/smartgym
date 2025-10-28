import 'dart:convert';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../data/models/challenge_model.dart';

class ChallengesController extends GetxController {
  final RxList<ChallengeModel> challenges = <ChallengeModel>[].obs;

  static const _key = 'challenges.joined';

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    challenges.assignAll(_seedChallenges());
    final raw = AppInitializer.prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return;
    }
    final map = jsonDecode(raw) as Map<String, dynamic>;
    challenges.assignAll(challenges.map((challenge) {
      final stored = map[challenge.id] as Map<String, dynamic>?;
      if (stored == null) return challenge;
      return challenge.copyWith(
        joined: stored['joined'] as bool? ?? challenge.joined,
        progress: (stored['progress'] as num?)?.toDouble() ?? challenge.progress,
      );
    }).toList());
  }

  Future<void> toggleJoin(String id) async {
    final index = challenges.indexWhere((element) => element.id == id);
    if (index == -1) return;
    final challenge = challenges[index];
    final updated = challenge.copyWith(joined: !challenge.joined);
    challenges[index] = updated;
    await _persist();
  }

  Future<void> updateProgress(String id, double value) async {
    final index = challenges.indexWhere((element) => element.id == id);
    if (index == -1) return;
    final challenge = challenges[index];
    challenges[index] = challenge.copyWith(progress: value.clamp(0, 1));
    await _persist();
  }

  ChallengeModel? findById(String id) => challenges.firstWhereOrNull((element) => element.id == id);

  Future<void> _persist() async {
    final map = {
      for (final challenge in challenges)
        challenge.id: {'joined': challenge.joined, 'progress': challenge.progress},
    };
    await AppInitializer.prefs.setString(_key, jsonEncode(map));
  }

  List<ChallengeModel> _seedChallenges() {
    final now = DateTime.now();
    return [
      ChallengeModel(
        id: 'steps_week',
        title: 'Weekly Steps Blast',
        type: 'steps',
        start: now,
        end: now.add(const Duration(days: 7)),
        goal: '70000 steps',
        joined: false,
        progress: 0.0,
      ),
      ChallengeModel(
        id: 'classes_attend',
        title: 'Attend 4 classes',
        type: 'attendance',
        start: now,
        end: now.add(const Duration(days: 10)),
        goal: '4 sessions',
        joined: false,
        progress: 0.0,
      ),
      ChallengeModel(
        id: 'calories_burn',
        title: 'Burn 3000 kcal',
        type: 'calories',
        start: now,
        end: now.add(const Duration(days: 14)),
        goal: '3000 kcal',
        joined: false,
        progress: 0.0,
      ),
    ];
  }
}
