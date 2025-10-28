import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sleep_controller.dart';

class SleepCoachPage extends GetView<SleepController> {
  const SleepCoachPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('sleep_coach'.tr)),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text('bedtime'.tr),
              subtitle: Text(controller.plan.value.bedtime),
              trailing: const Icon(Icons.schedule),
              onTap: () => _showTimePicker(context, true),
            ),
            ListTile(
              title: Text('wake_time'.tr),
              subtitle: Text(controller.plan.value.wakeTime),
              trailing: const Icon(Icons.alarm),
              onTap: () => _showTimePicker(context, false),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'notes'.tr),
              onChanged: controller.updateNotes,
            ),
            const SizedBox(height: 16),
            Text('tips', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...controller.tips.map((tip) => ListTile(leading: const Icon(Icons.check), title: Text(tip))),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text('reminders'.tr),
              subtitle: controller.alarmEnabled.value
                  ? Text('${'countdown'.tr}: ${controller.alarmCountdown.value}s')
                  : Text('disabled'.tr),
              value: controller.alarmEnabled.value,
              onChanged: controller.toggleAlarm,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context, bool isBedtime) async {
    final controller = Get.find<SleepController>();
    final initial = isBedtime ? controller.plan.value.bedtime : controller.plan.value.wakeTime;
    final parts = initial.split(':');
    final time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    final picked = await showTimePicker(context: context, initialTime: time);
    if (picked == null) return;
    final formatted = picked.format(context);
    if (isBedtime) {
      await controller.setBedtime(formatted);
    } else {
      await controller.setWakeTime(formatted);
    }
  }
}
