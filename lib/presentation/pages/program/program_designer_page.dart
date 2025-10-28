import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/program_controller.dart';
import '../../controllers/schedule_controller.dart';

class ProgramDesignerPage extends GetView<ProgramController> {
  const ProgramDesignerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final schedule = Get.find<ScheduleController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('program_designer'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () => _showSaveDialog(context),
            tooltip: 'save'.tr,
          ),
        ],
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('weekly_split'.tr, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...controller.days.map((day) => _ProgramDayCard(controller: controller, dayKey: day.weekday)).toList(),
            const SizedBox(height: 24),
            if (controller.conflicts.isNotEmpty) ...[
              Text('conflicts'.tr, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...controller.conflicts.map(
                (item) => ListTile(
                  leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  title: Text(item),
                  subtitle: Text('resolve'.tr),
                  onTap: () => Get.snackbar('conflicts'.tr, 'resolve'.tr),
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => _showSaveDialog(context),
              child: Obx(() {
                final existing = controller.program.value;
                final label = existing == null ? 'build_program'.tr : '${'save'.tr} (${existing.name})';
                return Text(label);
              }),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                await schedule.refreshData();
                controller.reload();
              },
              child: Text('refresh'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSaveDialog(BuildContext context) async {
    final nameController = TextEditingController(text: controller.program.value?.name ?? '');
    final goalController = TextEditingController(text: controller.program.value?.goal ?? '');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('build_program'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'name'.tr),
            ),
            TextField(
              controller: goalController,
              decoration: InputDecoration(labelText: 'goal'.tr),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('cancel'.tr)),
          FilledButton(
            onPressed: () async {
              await controller.saveProgram(nameController.text.isEmpty ? 'program_designer'.tr : nameController.text,
                  goalController.text.isEmpty ? 'weekly_split'.tr : goalController.text);
              Get.back();
              Get.snackbar('program_designer'.tr, 'success'.tr);
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }
}

class _ProgramDayCard extends StatelessWidget {
  const _ProgramDayCard({required this.controller, required this.dayKey});

  final ProgramController controller;
  final String dayKey;

  @override
  Widget build(BuildContext context) {
    final classes = controller.classesForDay(dayKey);
    final title = dayKey.tr;
    final suggestions = controller.suggestionsForDay(dayKey);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _showAddSheet(context, suggestions),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: classes
                  .map(
                    (item) => InputChip(
                      label: Text(item.title),
                      onDeleted: () => controller.removeClass(dayKey, item.id),
                    ),
                  )
                  .toList(),
            ),
            if (classes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('no_results'.tr, style: Theme.of(context).textTheme.bodySmall),
              ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(labelText: 'notes'.tr),
              onChanged: (value) => controller.updateNotes(dayKey, value),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context, List suggestions) {
    if (suggestions.isEmpty) {
      Get.snackbar('program_designer'.tr, 'no_results'.tr);
      return;
    }
    Get.bottomSheet(
      SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: suggestions
              .map<Widget>(
                (item) => ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.level),
                  onTap: () {
                    controller.addClass(dayKey, item.id);
                    Get.back();
                  },
                ),
              )
              .toList(),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
