import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/trainer_model.dart';

class TrainerDetailsPage extends StatelessWidget {
  const TrainerDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TrainerModel trainer = Get.arguments as TrainerModel;
    return Scaffold(
      appBar: AppBar(title: Text(trainer.name)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CircleAvatar(radius: 48, child: Text(trainer.name.substring(0, 1))),
          const SizedBox(height: 16),
          Text(trainer.bio, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Text('Specialties', style: Theme.of(context).textTheme.titleMedium),
          Wrap(spacing: 8, children: trainer.specialties.map((e) => Chip(label: Text(e))).toList()),
          const SizedBox(height: 16),
          Text('certifications'.tr, style: Theme.of(context).textTheme.titleMedium),
          Column(children: trainer.certifications.map((e) => ListTile(leading: const Icon(Icons.verified), title: Text(e))).toList()),
          const SizedBox(height: 16),
          Text('rates'.tr, style: Theme.of(context).textTheme.titleMedium),
          ...trainer.rates.entries.map((e) => ListTile(title: Text(e.key), trailing: Text('${e.value} USD'))),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Get.snackbar('success'.tr, 'personal_requested'.tr),
            child: Text('book_personal'.tr),
          ),
        ],
      ),
    );
  }
}
