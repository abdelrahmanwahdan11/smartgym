import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/share_card_controller.dart';

class ShareCardPage extends GetView<ShareCardController> {
  const ShareCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('share_card'.tr), actions: [IconButton(onPressed: _export, icon: const Icon(Icons.download))]),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: RepaintBoundary(
                key: controller.repaintKey,
                child: Obx(() => _ShareCardView(
                      showName: controller.showName.value,
                      showStats: controller.showStats.value,
                      showBadges: controller.showBadges.value,
                      showGym: controller.showGym.value,
                    )),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => SwitchListTile(
                  title: const Text('Show name'),
                  value: controller.showName.value,
                  onChanged: controller.toggleName,
                )),
            Obx(() => SwitchListTile(
                  title: const Text('Show stats'),
                  value: controller.showStats.value,
                  onChanged: controller.toggleStats,
                )),
            Obx(() => SwitchListTile(
                  title: const Text('Show badges'),
                  value: controller.showBadges.value,
                  onChanged: controller.toggleBadges,
                )),
            Obx(() => SwitchListTile(
                  title: const Text('Show gym'),
                  value: controller.showGym.value,
                  onChanged: controller.toggleGym,
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _export() async {
    final data = await controller.exportPng();
    if (data == null) {
      Get.snackbar('Error', 'Failed to export');
      return;
    }
    final bytes = data.buffer.asUint8List();
    Get.snackbar('Exported', 'PNG size ${bytes.length} bytes');
  }
}

class _ShareCardView extends StatelessWidget {
  const _ShareCardView({
    required this.showName,
    required this.showStats,
    required this.showBadges,
    required this.showGym,
  });

  final bool showName;
  final bool showStats;
  final bool showBadges;
  final bool showGym;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showName)
            Text('Lina K.',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          if (showStats) ...[
            const SizedBox(height: 16),
            const Text('Weight: 62kg', style: TextStyle(color: Colors.white)),
            const Text('Body Fat: 19%', style: TextStyle(color: Colors.white)),
          ],
          if (showBadges) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Streak 7d'), backgroundColor: Colors.white24),
                Chip(label: Text('HIIT Pro'), backgroundColor: Colors.white24),
              ],
            ),
          ],
          if (showGym) ...[
            const Spacer(),
            const Text('Velocity Fitness', style: TextStyle(color: Colors.white70)),
          ],
        ],
      ),
    );
  }
}
