import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/challenges_controller.dart';

class ChallengeDetailsPage extends StatelessWidget {
  const ChallengeDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChallengesController>();
    final String challengeId = Get.parameters['id'] ?? Get.arguments as String;
    final challenge = controller.findById(challengeId);
    if (challenge == null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text('no_results'.tr)));
    }
    return Scaffold(
      appBar: AppBar(title: Text(challenge.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'challenge'.tr}: ${challenge.title}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('${'start'.tr}: ${challenge.start.toLocal().toString().split(' ').first}'),
            Text('${'end'.tr}: ${challenge.end.toLocal().toString().split(' ').first}'),
            Text('${'goal'.tr}: ${challenge.goal}'),
            const SizedBox(height: 16),
            Text('progress'.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Obx(() {
              final refreshed = controller.findById(challengeId)!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(value: refreshed.progress),
                  Slider(
                    value: refreshed.progress,
                    onChanged: (value) => controller.updateProgress(challengeId, value),
                  ),
                  Text('${(refreshed.progress * 100).round()}%'),
                ],
              );
            }),
            const SizedBox(height: 24),
            Text('leaderboard', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  ListTile(title: const Text('You'), trailing: Obx(() {
                    final refreshed = controller.findById(challengeId)!;
                    return Text('${(refreshed.progress * 100).round()}%');
                  })),
                  const ListTile(title: Text('Lina'), trailing: Text('76%')),
                  const ListTile(title: Text('Rami'), trailing: Text('65%')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
