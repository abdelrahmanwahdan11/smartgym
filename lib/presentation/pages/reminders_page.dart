import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/reminder_model.dart';
import '../controllers/reminders_controller.dart';

class RemindersPage extends GetView<RemindersController> {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('reminders'.tr)),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.reminders.isEmpty) {
          return const Center(child: Text('No reminders configured'));
        }
        return ListView.builder(
          itemCount: controller.reminders.length,
          itemBuilder: (context, index) {
            final reminder = controller.reminders[index];
            return SwitchListTile(
              title: Text('Class ${reminder.classId}'),
              subtitle: Text('At ${reminder.time}'),
              value: reminder.enabled,
              onChanged: (value) => controller.toggleReminder(reminder.id, value),
            );
          },
        );
      }),
    );
  }

  void _addReminder() {
    controller.addReminder(ReminderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      classId: 'class_101',
      time: DateTime.now().add(const Duration(minutes: 1)),
      itemsToBring: const ['Towel', 'Water'],
      enabled: true,
    ));
  }
}
