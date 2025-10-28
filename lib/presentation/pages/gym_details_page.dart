import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/gym_model.dart';

class GymDetailsPage extends StatelessWidget {
  const GymDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GymModel gym = Get.arguments as GymModel;
    return Scaffold(
      appBar: AppBar(title: Text(gym.name)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: const Center(child: Icon(Icons.home_work_outlined, size: 64)),
          ),
          const SizedBox(height: 16),
          Text(gym.locationText, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Text('Amenities', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: gym.amenities.map((e) => Chip(label: Text(e))).toList()),
          const SizedBox(height: 16),
          Text('Equipment', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Column(children: gym.equipment.map((e) => ListTile(leading: const Icon(Icons.circle, size: 8), title: Text(e))).toList()),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => Get.toNamed('/classes'), child: const Text('View classes')),
        ],
      ),
    );
  }
}
