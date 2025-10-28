import 'dart:convert';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../data/models/buddy_profile_model.dart';

class BuddyController extends GetxController {
  final Rx<BuddyProfileModel?> profile = Rx<BuddyProfileModel?>(null);
  final RxList<BuddyProfileModel> matches = <BuddyProfileModel>[].obs;

  static const _key = 'buddy.pref';

  final List<String> goalOptions = const ['Strength', 'Cardio', 'Mobility', 'Weight loss', 'Hypertrophy'];
  final List<String> dayOptions = const ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    final raw = AppInitializer.prefs.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      profile.value = BuddyProfileModel.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    }
    _refreshMatches();
  }

  Future<void> saveProfile({
    required String name,
    required List<String> goals,
    required List<String> days,
    required List<String> gyms,
  }) async {
    final model = BuddyProfileModel(
      id: 'me',
      name: name,
      goals: goals,
      availableDays: days,
      nearbyGymIds: gyms,
    );
    profile.value = model;
    await AppInitializer.prefs.setString(_key, jsonEncode(model.toMap()));
    _refreshMatches();
  }

  void _refreshMatches() {
    final pool = _seedPool();
    final me = profile.value;
    if (me == null) {
      matches.assignAll(pool.take(3));
      return;
    }
    final filtered = pool.where((candidate) {
      final goalOverlap = candidate.goals.any(me.goals.contains);
      final dayOverlap = candidate.availableDays.any(me.availableDays.contains);
      final gymOverlap = candidate.nearbyGymIds.any(me.nearbyGymIds.contains);
      final score = [goalOverlap, dayOverlap, gymOverlap].where((element) => element).length;
      return score >= 2;
    }).toList();
    matches.assignAll(filtered.isEmpty ? pool.take(3).toList() : filtered);
  }

  List<BuddyProfileModel> _seedPool() {
    return [
      BuddyProfileModel(
        id: 'buddy1',
        name: 'Rana',
        goals: ['Strength', 'Mobility'],
        availableDays: ['mon', 'wed', 'fri'],
        nearbyGymIds: ['gym_001', 'gym_002'],
      ),
      BuddyProfileModel(
        id: 'buddy2',
        name: 'Omar',
        goals: ['Cardio', 'Weight loss'],
        availableDays: ['tue', 'thu', 'sat'],
        nearbyGymIds: ['gym_003'],
      ),
      BuddyProfileModel(
        id: 'buddy3',
        name: 'Layla',
        goals: ['Hypertrophy', 'Strength'],
        availableDays: ['mon', 'thu', 'sun'],
        nearbyGymIds: ['gym_001'],
      ),
      BuddyProfileModel(
        id: 'buddy4',
        name: 'Ziad',
        goals: ['Mobility', 'Cardio'],
        availableDays: ['wed', 'fri', 'sun'],
        nearbyGymIds: ['gym_002', 'gym_004'],
      ),
    ];
  }
}
