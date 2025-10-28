import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/steps_controller.dart';
import '../../widgets/simple_line_chart.dart';

class StepsPage extends GetView<StepsController> {
  const StepsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('steps'.tr)),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                title: Text('todays_steps'.tr),
                subtitle: Text('${controller.todaySteps.value} / ${controller.target.value}'),
                trailing: FilledButton(
                  onPressed: controller.mockStepBurst,
                  child: Text('add_item'.tr),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('target'.tr, style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: controller.target.value.toDouble(),
              min: 2000,
              max: 20000,
              divisions: 18,
              label: controller.target.value.toString(),
              onChanged: (value) => controller.setTarget(value.round()),
            ),
            const SizedBox(height: 16),
            Text('progress'.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SimpleLineChart(values: controller.weeklyChart.map((e) => e.toDouble()).toList()),
          ],
        ),
      ),
    );
  }
}
