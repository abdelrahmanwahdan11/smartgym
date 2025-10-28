import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/class_model.dart';
import '../../data/models/reminder_model.dart';
import '../controllers/reminders_controller.dart';
import '../controllers/schedule_controller.dart';

class RemindersPage extends GetView<RemindersController> {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final schedule = Get.find<ScheduleController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('reminders'.tr),
        actions: [
          IconButton(onPressed: controller.clearAll, icon: const Icon(Icons.delete_sweep)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addReminder(context, schedule),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.reminders.isEmpty) {
          return Center(child: Text('reminders_empty'.tr));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.reminders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final reminder = controller.reminders[index];
            final classModel = schedule.classFor(reminder.classId);
            final time = TimeOfDay.fromDateTime(reminder.time);
            final items = reminder.itemsToBring.join(', ');
            return Card(
              child: ListTile(
                title: Text(classModel?.title ?? reminder.classId),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('reminder_time_label'.trParams({
                      'time': time.format(context),
                    })),
                    const SizedBox(height: 4),
                    Text(items.isEmpty ? 'reminder_no_items'.tr : items),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: reminder.enabled,
                      onChanged: (value) => controller.toggleReminder(reminder.id, value),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => controller.removeReminder(reminder.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Future<void> _addReminder(BuildContext context, ScheduleController schedule) async {
    var classes = schedule.availableClasses;
    if (classes.isEmpty) {
      await schedule.refreshData();
      classes = schedule.availableClasses;
    }
    if (classes.isEmpty) {
      Get.snackbar('reminders'.tr, 'reminder_no_classes'.tr);
      return;
    }
    var selected = classes.first;
    var dateTime = DateTime.now().add(const Duration(minutes: 10));
    var enabled = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
          ),
          child: StatefulBuilder(builder: (context, setState) {
            final defaultItems = controller.itemsByClassType[selected.type] ?? const <String>[];
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('reminders_create_title'.tr, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                DropdownButton<ClassModel>(
                  value: selected,
                  isExpanded: true,
                  onChanged: (value) => setState(() => selected = value ?? selected),
                  items: classes
                      .map((c) => DropdownMenuItem(value: c, child: Text(c.title)))
                      .toList(),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('reminder_time_pick'.tr),
                  subtitle: Text(TimeOfDay.fromDateTime(dateTime).format(context)),
                  onTap: () async {
                    final initial = TimeOfDay.fromDateTime(dateTime);
                    final picked = await showTimePicker(context: context, initialTime: initial);
                    if (picked != null) {
                      final now = DateTime.now();
                      setState(() {
                        dateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                        if (dateTime.isBefore(now)) {
                          dateTime = dateTime.add(const Duration(days: 1));
                        }
                      });
                    }
                  },
                ),
                Wrap(
                  spacing: 8,
                  children: defaultItems.map((e) => Chip(label: Text(e))).toList(),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('reminder_enabled'.tr),
                  value: enabled,
                  onChanged: (value) => setState(() => enabled = value),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      controller.addReminder(ReminderModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        classId: selected.id,
                        time: dateTime,
                        itemsToBring: defaultItems,
                        enabled: enabled,
                      ));
                      Navigator.of(context).pop();
                    },
                    child: Text('save'.tr),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
