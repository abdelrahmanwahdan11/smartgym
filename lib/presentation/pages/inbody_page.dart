import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/inbody_record_model.dart';
import '../controllers/inbody_controller.dart';
import '../widgets/simple_line_chart.dart';

class InBodyPage extends GetView<InBodyController> {
  const InBodyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final weightController = TextEditingController();
    final fatController = TextEditingController();
    final muscleController = TextEditingController();
    final waterController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text('inbody'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Obx(() => _MetricsGrid(
                weight: controller.latestWeight,
                bodyFat: controller.latestBodyFat,
                muscle: controller.latestMuscle,
                water: controller.latestWater,
              )),
          const SizedBox(height: 24),
          Text('Add record', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _NumberField(label: 'Weight (kg)', controller: weightController),
          _NumberField(label: 'Body fat %', controller: fatController),
          _NumberField(label: 'Muscle (kg)', controller: muscleController),
          _NumberField(label: 'Water (L)', controller: waterController),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              controller.addRecord(InBodyRecordModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                date: DateTime.now(),
                weight: double.tryParse(weightController.text) ?? 0,
                bodyFat: double.tryParse(fatController.text) ?? 0,
                muscle: double.tryParse(muscleController.text) ?? 0,
                water: double.tryParse(waterController.text) ?? 0,
                waist: 0,
                hip: 0,
                notes: '',
              ));
              Get.snackbar('Saved', 'Record stored locally');
            },
            child: const Text('Save'),
          ),
          const SizedBox(height: 24),
          Obx(() => SimpleLineChart(values: controller.metricHistory((e) => e.weight))),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.weight, required this.bodyFat, required this.muscle, required this.water});

  final double weight;
  final double bodyFat;
  final double muscle;
  final double water;

  @override
  Widget build(BuildContext context) {
    final items = [
      _MetricCard(label: 'Weight', value: weight, unit: 'kg'),
      _MetricCard(label: 'Body fat', value: bodyFat, unit: '%'),
      _MetricCard(label: 'Muscle', value: muscle, unit: 'kg'),
      _MetricCard(label: 'Water', value: water, unit: 'L'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: items,
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.unit});

  final String label;
  final double value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const Spacer(),
          Text(value.toStringAsFixed(1), style: Theme.of(context).textTheme.headlineMedium),
          Text(unit),
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
