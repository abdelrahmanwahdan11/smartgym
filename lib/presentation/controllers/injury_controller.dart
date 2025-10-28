import 'dart:convert';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../data/models/injury_adapt_model.dart';

class InjuryController extends GetxController {
  final Rx<InjuryAdaptModel> adaptation =
      InjuryAdaptModel(enabled: false, disallowedMovements: const [], alternativesNote: '').obs;

  static const _key = 'injury.adapt';

  final List<String> movementOptions = const [
    'Deep squats',
    'Overhead press',
    'Burpees',
    'Box jumps',
    'Sprints',
  ];

  final Map<String, List<String>> alternativeSuggestions = const {
    'Deep squats': ['Goblet squat', 'Split squat'],
    'Overhead press': ['Landmine press', 'Arnold press (light)'],
    'Burpees': ['Step-down burpees', 'Mountain climbers'],
    'Box jumps': ['Box step-ups', 'Low pogo jumps'],
    'Sprints': ['Bike intervals', 'Row erg'],
  };

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    final raw = AppInitializer.prefs.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      adaptation.value = InjuryAdaptModel.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    }
  }

  Future<void> toggleEnabled(bool value) async {
    adaptation.value = adaptation.value.copyWith(enabled: value);
    await _persist();
  }

  Future<void> toggleMovement(String movement) async {
    final current = adaptation.value.disallowedMovements.toList();
    if (current.contains(movement)) {
      current.remove(movement);
    } else {
      current.add(movement);
    }
    adaptation.value = adaptation.value.copyWith(disallowedMovements: current);
    await _persist();
  }

  Future<void> updateNotes(String value) async {
    adaptation.value = adaptation.value.copyWith(alternativesNote: value);
    await _persist();
  }

  bool isMovementBlocked(String movement) => adaptation.value.disallowedMovements.contains(movement);

  Future<void> _persist() async {
    await AppInitializer.prefs.setString(_key, jsonEncode(adaptation.value.toMap()));
  }
}
