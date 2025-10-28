import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/challenges_controller.dart';
import '../controllers/share_card_controller.dart';

class ShareCardPage extends GetView<ShareCardController> {
  const ShareCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final challenges = Get.find<ChallengesController>();
    final templates = ['classic', 'focus', 'coach'];
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
                      showChallenges: controller.showChallenges.value,
                      template: controller.template.value,
                      textScale: controller.textScale.value,
                      challengeTitles: challenges.challenges
                          .where((element) => element.joined)
                          .map((e) => e.title)
                          .toList(),
                    )),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => DropdownButton<String>(
                  value: controller.template.value,
                  items: templates
                      .map((template) => DropdownMenuItem(value: template, child: Text(template.tr)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) controller.setTemplate(value);
                  },
                )),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('text_scale'.tr),
                    Slider(
                      value: controller.textScale.value,
                      min: 0.8,
                      max: 1.4,
                      onChanged: controller.setTextScale,
                    ),
                  ],
                )),
            Obx(() => SwitchListTile(
                  title: Text('show_name'.tr),
                  value: controller.showName.value,
                  onChanged: controller.toggleName,
                )),
            Obx(() => SwitchListTile(
                  title: Text('show_stats'.tr),
                  value: controller.showStats.value,
                  onChanged: controller.toggleStats,
                )),
            Obx(() => SwitchListTile(
                  title: Text('show_badges'.tr),
                  value: controller.showBadges.value,
                  onChanged: controller.toggleBadges,
                )),
            Obx(() => SwitchListTile(
                  title: Text('show_gym'.tr),
                  value: controller.showGym.value,
                  onChanged: controller.toggleGym,
                )),
            Obx(() => SwitchListTile(
                  title: Text('show_challenges'.tr),
                  value: controller.showChallenges.value,
                  onChanged: controller.toggleChallenges,
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _export() async {
    final data = await controller.exportPng();
    if (data == null) {
      Get.snackbar('error'.tr, 'failed'.tr);
      return;
    }
    final bytes = data.buffer.asUint8List();
    Get.snackbar('export_data'.tr, '${bytes.length} B');
  }
}

class _ShareCardView extends StatelessWidget {
  const _ShareCardView({
    required this.showName,
    required this.showStats,
    required this.showBadges,
    required this.showGym,
    required this.showChallenges,
    required this.template,
    required this.textScale,
    required this.challengeTitles,
  });

  final bool showName;
  final bool showStats;
  final bool showBadges;
  final bool showGym;
  final bool showChallenges;
  final String template;
  final double textScale;
  final List<String> challengeTitles;

  @override
  Widget build(BuildContext context) {
    final gradient = _templateGradient(context, template);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: gradient,
      ),
      padding: const EdgeInsets.all(24),
      child: DefaultTextStyle(
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.white, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize! * textScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showName)
              Text('Lina K.',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 28 * textScale)),
            if (showStats) ...[
              const SizedBox(height: 16),
              Text('Weight: 62kg'),
              Text('Body Fat: 19%'),
              Text('Muscle: 28kg'),
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
            if (showChallenges && challengeTitles.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: challengeTitles
                    .map((title) => Chip(
                          label: Text(title),
                          backgroundColor: Colors.white24,
                        ))
                    .toList(),
              ),
            ],
            if (showGym) ...[
              const Spacer(),
              const Text('Velocity Fitness', style: TextStyle(color: Colors.white70)),
            ],
          ],
        ),
      ),
    );
  }

  Gradient _templateGradient(BuildContext context, String template) {
    final base = Theme.of(context).colorScheme.primary;
    switch (template) {
      case 'focus':
        return LinearGradient(colors: [base, Colors.deepPurple]);
      case 'coach':
        return LinearGradient(colors: [Colors.black87, Colors.blueGrey.shade700]);
      default:
        return LinearGradient(colors: [base, base.withOpacity(0.7)]);
    }
  }
}
