import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/timers_controller.dart';

class TimersPage extends GetView<TimersController> {
  const TimersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modeLabels = {
      TimerMode.hiit: 'hiit'.tr,
      TimerMode.emom: 'emom'.tr,
      TimerMode.amrap: 'amrap'.tr,
      TimerMode.tabata: 'tabata'.tr,
    };
    return Scaffold(
      appBar: AppBar(title: Text('timers'.tr)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: modeLabels.entries
                      .map(
                        (entry) => ChoiceChip(
                          label: Text(entry.value),
                          selected: controller.mode.value == entry.key,
                          onSelected: (_) => controller.setMode(entry.key),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 32),
              Obx(() {
                final formatted = _formatSeconds(controller.timeLeft.value);
                final phase = controller.isWorkPhase.value ? 'work'.tr : 'rest'.tr;
                final round = '${controller.currentRound.value}/${controller.rounds.value}';
                return Column(
                  children: [
                    Animate(
                      key: ValueKey('${controller.timeLeft.value}_${controller.isWorkPhase.value}'),
                      effects: const [FadeEffect(duration: Duration(milliseconds: 300)), ScaleEffect(begin: Offset(0.98, 0.98), end: Offset(1, 1), duration: Duration(milliseconds: 280))],
                      child: Text(
                        formatted,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 64),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('$phase · $round', style: Theme.of(context).textTheme.titleMedium),
                  ],
                );
              }),
              const SizedBox(height: 32),
              _DurationSlider(
                label: 'work'.tr,
                value: controller.workSeconds,
                onChanged: controller.setWorkSeconds,
                min: 5,
                max: 600,
                step: 5,
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.mode.value == TimerMode.amrap) {
                  return const SizedBox.shrink();
                }
                return _DurationSlider(
                  label: 'rest'.tr,
                  value: controller.restSeconds,
                  onChanged: controller.setRestSeconds,
                  min: 0,
                  max: 300,
                  step: 5,
                );
              }),
              const SizedBox(height: 16),
              _DurationSlider(
                label: 'rounds'.tr,
                value: controller.rounds,
                onChanged: controller.setRounds,
                min: 1,
                max: 30,
                step: 1,
                isRoundSelector: true,
              ),
              const Spacer(),
              Obx(() => Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: controller.isRunning.value ? null : controller.start,
                          child: Text('start'.tr),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: controller.isRunning.value ? controller.stop : null,
                          child: Text('stop'.tr),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.reset,
                          child: Text('reset'.tr),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSeconds(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$secs';
    }
    return '$minutes:$secs';
  }
}

class _DurationSlider extends StatelessWidget {
  const _DurationSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.step,
    this.isRoundSelector = false,
  });

  final String label;
  final RxInt value;
  final void Function(int) onChanged;
  final int min;
  final int max;
  final int step;
  final bool isRoundSelector;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = value.value;
      final divisions = ((max - min) / step).round();
      final display = isRoundSelector
          ? current.toString()
          : Duration(seconds: current).toString().split('.').first.padLeft(8, '0');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              Text(display, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          Slider(
            value: current.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: divisions > 0 ? divisions : null,
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      );
    });
  }
}
