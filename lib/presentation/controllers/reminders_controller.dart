import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/reminder_model.dart';

class RemindersController extends GetxController {
  final RxList<ReminderModel> reminders = <ReminderModel>[].obs;
  final Map<String, Timer> _timers = {};

  void addReminder(ReminderModel reminder) {
    reminders.add(reminder);
    _schedule(reminder);
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
