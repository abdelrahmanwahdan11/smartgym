import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/diet_controller.dart';

class GroceryListPage extends GetView<DietController> {
  const GroceryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('grocery_list'.tr)),
      body: Obx(() {
        final items = controller.groceryItems;
        if (items.isEmpty) {
          return Center(child: Text('no_results'.tr));
        }
        return ReorderableListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          onReorder: (oldIndex, newIndex) => controller.reorder(oldIndex, newIndex),
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              key: ValueKey(item.id),
              title: Text(item.title),
              leading: Checkbox(
                value: item.checked,
                onChanged: (_) => controller.toggleItem(item.id),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => controller.removeItem(item.id),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addItem(BuildContext context) async {
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
