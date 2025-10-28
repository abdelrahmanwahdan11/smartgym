import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/hydration_controller.dart';

class HydrationPage extends GetView<HydrationController> {
  const HydrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('hydration'.tr)),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('daily_goal_liters'.tr, style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: controller.goalLiters.value,
              min: 1,
              max: 5,
              divisions: 8,
              label: controller.goalLiters.value.toStringAsFixed(1),
              onChanged: (value) => controller.setGoal(value),
            ),
            Text('${controller.goalLiters.value.toStringAsFixed(1)} L'),
            const SizedBox(height: 16),
            Text('log_water'.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _QuickButton(label: '250 ml', onTap: () => controller.logWater(250)),
                _QuickButton(label: '500 ml', onTap: () => controller.logWater(500)),
                _QuickButton(label: '750 ml', onTap: () => controller.logWater(750)),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text('total'.tr),
                subtitle: Text('${controller.todayTotal.value} ml • ${(controller.todayTotal.value / 1000).toStringAsFixed(2)} L'),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text('reminders'.tr),
              subtitle: controller.reminderEnabled.value
                  ? Text('${'countdown'.tr}: ${controller.reminderCountdown.value}s')
                  : Text('disabled'.tr),
              value: controller.reminderEnabled.value,
              onChanged: controller.toggleReminder,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  const _QuickButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onTap, child: Text(label));
  }
}
