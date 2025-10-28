import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/challenges_controller.dart';
import '../../../core/routes/app_routes.dart';

class ChallengesPage extends GetView<ChallengesController> {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('challenges'.tr)),
      body: Obx(() {
        if (controller.challenges.isEmpty) {
          return Center(child: Text('no_results'.tr));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.challenges.length,
          itemBuilder: (context, index) {
            final challenge = controller.challenges[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(challenge.title, style: Theme.of(context).textTheme.titleMedium)),
                        IconButton(
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () => Get.toNamed('${AppRoutes.challengeDetails}/${challenge.id}', arguments: challenge.id),
                        ),
                      ],
                    ),
                    Text('${'goal'.tr}: ${challenge.goal}', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: challenge.progress.clamp(0, 1)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        FilledButton.tonal(
                          onPressed: () => controller.toggleJoin(challenge.id),
                          child: Text(challenge.joined ? 'cancel'.tr : 'join_challenge'.tr),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Slider(
                            value: challenge.progress,
                            min: 0,
                            max: 1,
                            divisions: 10,
                            label: '${(challenge.progress * 100).round()}%',
                            onChanged: (value) => controller.updateProgress(challenge.id, value),
                          ),
                        ),
                      ],
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
}
