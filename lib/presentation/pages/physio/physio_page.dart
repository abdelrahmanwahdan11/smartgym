import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhysioPage extends StatelessWidget {
  const PhysioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      {'title': 'Mobility check', 'date': '2025-03-10'},
      {'title': 'Sports massage', 'date': '2025-03-18'},
    ];
    final exercises = [
      '90/90 hip rotations',
      'Thoracic bridge',
      'Banded ankle mobilizations',
    ];
    return Scaffold(
      appBar: AppBar(title: Text('physio'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('appointments'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...appointments.map((item) => Card(
                child: ListTile(
                  title: Text(item['title']!),
                  subtitle: Text(item['date']!),
                ),
              )),
          const SizedBox(height: 16),
          Text('exercises'.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...exercises.map((exercise) => ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(exercise))),
        ],
      ),
    );
  }
}
