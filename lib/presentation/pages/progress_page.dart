import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/achievement_model.dart';
import '../../data/repositories/achievements_repository.dart';
import '../controllers/inbody_controller.dart';
import '../widgets/simple_line_chart.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final _repo = AchievementsRepository();
  List<AchievementModel> _achievements = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _repo.fetchAchievements();
    setState(() => _achievements = data);
  }

  @override
  Widget build(BuildContext context) {
    final inbody = Get.find<InBodyController>();
    return Scaffold(
      appBar: AppBar(title: Text('progress'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Weight trend', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Obx(() => SimpleLineChart(values: inbody.metricHistory((e) => e.weight))),
          const SizedBox(height: 24),
          Text('Achievements', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          if (_achievements.isEmpty)
            const Text('No achievements yet')
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _achievements
                  .map((achievement) => Chip(
                        label: Text('${achievement.label} (${achievement.value})'),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
