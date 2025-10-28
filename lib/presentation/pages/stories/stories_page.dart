import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  final RxBool consent = false.obs;
  final RxList<Map<String, String>> stories = <Map<String, String>>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('stories'.tr)),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: consent.value ? _addStory : null,
          child: const Icon(Icons.add_a_photo),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(
              () => SwitchListTile(
                title: Text('consent_required'.tr),
                value: consent.value,
                onChanged: consent,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (!consent.value) {
                return Expanded(
                  child: Center(
                    child: Text('consent_required'.tr),
                  ),
                );
              }
              if (stories.isEmpty) {
                return Expanded(child: Center(child: Text('no_results'.tr)));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return Card(
                      child: ListTile(
                        title: Text(story['title'] ?? ''),
                        subtitle: Text(story['description'] ?? ''),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _addStory() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('new_post'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'title'.tr)),
            TextField(controller: descController, decoration: InputDecoration(labelText: 'description'.tr)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('cancel'.tr)),
          FilledButton(
            onPressed: () {
              stories.add({'title': titleController.text, 'description': descController.text});
              Get.back();
            },
            child: Text('post'.tr),
          ),
        ],
      ),
    );
  }
}
