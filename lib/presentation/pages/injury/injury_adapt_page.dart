import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/injury_controller.dart';

class InjuryAdaptPage extends GetView<InjuryController> {
  const InjuryAdaptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('injury_mode'.tr)),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: Text('injury_mode'.tr),
              value: controller.adaptation.value.enabled,
              onChanged: controller.toggleEnabled,
            ),
            const SizedBox(height: 8),
            Text('Select movements to pause', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...controller.movementOptions.map(
              (movement) => CheckboxListTile(
                title: Text(movement),
                value: controller.isMovementBlocked(movement),
                onChanged: (_) => controller.toggleMovement(movement),
              ),
            ),
            const SizedBox(height: 16),
            Text('Alternatives', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...controller.adaptation.value.disallowedMovements.map((movement) {
              final alternatives = controller.alternativeSuggestions[movement] ?? [];
              return ListTile(
                title: Text(movement),
                subtitle: Text(alternatives.join(', ')),
              );
            }),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'notes'.tr),
              onChanged: controller.updateNotes,
            ),
          ],
        ),
      ),
    );
  }
}
