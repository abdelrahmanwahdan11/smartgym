import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/diet_controller.dart';
import '../../../core/routes/app_routes.dart';

class DietPlannerPage extends GetView<DietController> {
  const DietPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final templates = ['custom', 'cut', 'bulk', 'if', 'keto'];
    final templateLabels = {
      'custom': 'custom',
      'cut': 'cut',
      'bulk': 'bulk',
      'if': 'if',
      'keto': 'keto',
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('diet_planner'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () => Get.toNamed(AppRoutes.grocery),
            tooltip: 'grocery_list'.tr,
          ),
        ],
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('macros'.tr, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _MacroTile(label: 'protein'.tr, value: '${controller.macroPlan.value.proteinG}g'),
            _MacroTile(label: 'carbs'.tr, value: '${controller.macroPlan.value.carbsG}g'),
            _MacroTile(label: 'fat'.tr, value: '${controller.macroPlan.value.fatG}g'),
            _MacroTile(label: 'calories', value: '${controller.macroPlan.value.calories} kcal'),
            const SizedBox(height: 16),
            Text('templates'.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: templates
                  .map((template) => ChoiceChip(
                        label: Text(templateLabels[template]!.tr),
                        selected: controller.macroPlan.value.template == template,
                        onSelected: (_) => controller.applyTemplate(template),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            Text('grocery_list'.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...controller.groceryItems.map((item) => CheckboxListTile(
                  title: Text(item.title),
                  value: item.checked,
                  onChanged: (_) => controller.toggleItem(item.id),
                )),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text('add_item'.tr),
              onTap: () => _promptAddItem(context),
            ),
            const SizedBox(height: 24),
            Text('recommended_meals'.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const ListTile(title: Text('Overnight oats'), subtitle: Text('Protein, berries, chia seeds')),
            const ListTile(title: Text('Grilled salmon'), subtitle: Text('Roasted veggies, quinoa')),
          ],
        ),
      ),
    );
  }

  Future<void> _promptAddItem(BuildContext context) async {
    final controller = Get.find<DietController>();
    final textController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_item'.tr),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(labelText: 'grocery_list'.tr),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('cancel'.tr)),
          FilledButton(
            onPressed: () async {
              await controller.addItem(textController.text);
              Get.back();
            },
            child: Text('add_item'.tr),
          ),
        ],
      ),
    );
  }
}

class _MacroTile extends StatelessWidget {
  const _MacroTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Text(value),
    );
  }
}
