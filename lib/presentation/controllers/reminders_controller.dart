import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import '../../core/app_initializer.dart';
import '../../data/models/reminder_model.dart';

class RemindersController extends GetxController {
  final RxList<ReminderModel> reminders = <ReminderModel>[].obs;
  final Map<String, Timer> _timers = {};

  final Map<String, List<String>> itemsByClassType = const {
    'HIIT': ['Towel', 'Water', 'Electrolytes'],
    'Yoga': ['Mat', 'Towel'],
    'Weights': ['Gloves', 'Belt (optional)'],
  };

  @override
  void onInit() {
    super.onInit();
    _restore();
  }

  Future<void> _restore() async {
    final raw = AppInitializer.prefs.getString('reminders.config');
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => ReminderModel.fromMap(e as Map<String, dynamic>))
          .toList();
      reminders.assignAll(list);
      for (final reminder in reminders.where((element) => element.enabled)) {
        _schedule(reminder);
      }
    }
  }

  Future<void> _persist() async {
    final encoded = jsonEncode(reminders.map((e) => e.toMap()).toList());
    await AppInitializer.prefs.setString('reminders.config', encoded);
  }

  void addReminder(ReminderModel reminder) {
    reminders.add(reminder);
    if (reminder.enabled) {
      _schedule(reminder);
    }
    _persist();
  }

  void toggleReminder(String id, bool enabled) {
    final index = reminders.indexWhere((element) => element.id == id);
    if (index == -1) return;
    final updated = reminders[index].copyWith(enabled: enabled);
    reminders[index] = updated;
    if (enabled) {
      _schedule(updated);
    } else {
      _timers[id]?.cancel();
    }
    _persist();
  }

  void removeReminder(String id) {
    reminders.removeWhere((element) => element.id == id);
    _timers[id]?.cancel();
    _persist();
  }

  void clearAll() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    reminders.clear();
    _persist();
  }

  void _schedule(ReminderModel reminder) {
    _timers[reminder.id]?.cancel();
    final delay = reminder.time.difference(DateTime.now());
    if (delay.isNegative) {
      return;
    }
    _timers[reminder.id] = Timer(delay, () {
      Get.snackbar('Reminder', 'Time for your class ${reminder.classId}');
    });
  }

  @override
  void onClose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    super.onClose();
  }
}
