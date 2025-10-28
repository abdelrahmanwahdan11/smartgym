import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../data/models/steps_day_model.dart';

class StepsController extends GetxController {
  final RxList<StepsDayModel> history = <StepsDayModel>[].obs;
  final RxInt target = 8000.obs;
  final RxInt todaySteps = 0.obs;

  static const _key = 'steps.history';
  static const _targetKey = 'steps.target';

  final _random = Random();

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  void _restore() {
    target.value = AppInitializer.prefs.getInt(_targetKey) ?? 8000;
    final raw = AppInitializer.prefs.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => StepsDayModel.fromMap(e as Map<String, dynamic>))
          .toList();
      history.assignAll(list);
    } else {
      _seedHistory();
    }
    _ensureTodayEntry();
  }

  void _seedHistory() {
    final now = DateTime.now();
    final generated = List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return StepsDayModel(
        date: DateTime(day.year, day.month, day.day),
        steps: 5000 + _random.nextInt(5000),
        target: target.value,
      );
    });
    history.assignAll(generated);
    _persist();
  }

  void _ensureTodayEntry() {
    final today = DateTime.now();
    final entryIndex = history.indexWhere((e) => _isSameDay(e.date, today));
    if (entryIndex == -1) {
      history.add(StepsDayModel(
        date: DateTime(today.year, today.month, today.day),
        steps: 0,
        target: target.value,
      ));
    }
    final entry = history.firstWhere((e) => _isSameDay(e.date, today));
    todaySteps.value = entry.steps;
  }

  Future<void> setTarget(int value) async {
    target.value = value;
    await AppInitializer.prefs.setInt(_targetKey, value);
    final today = DateTime.now();
    final index = history.indexWhere((element) => _isSameDay(element.date, today));
    if (index != -1) {
      history[index] = history[index].copyWith(target: value);
      await _persist();
    }
  }

  Future<void> mockStepBurst() async {
    final increment = 500 + _random.nextInt(800);
    final today = DateTime.now();
    final index = history.indexWhere((element) => _isSameDay(element.date, today));
    if (index == -1) return;
    final entry = history[index];
    history[index] = entry.copyWith(steps: entry.steps + increment);
    todaySteps.value = history[index].steps;
    await _persist();
  }

  List<int> get weeklyChart {
    final sorted = [...history]..sort((a, b) => a.date.compareTo(b.date));
    return sorted.takeLast(7).map((e) => e.steps).toList();
  }

  Future<void> _persist() async {
    await AppInitializer.prefs
        .setString(_key, jsonEncode(history.map((e) => e.toMap()).toList()));
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

extension<E> on List<E> {
  Iterable<E> takeLast(int count) {
    if (count >= length) return this;
    return sublist(length - count);
  }
}
